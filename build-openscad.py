#!/usr/bin/env python3
"""
build-openscad.py <model.scad>

Renders every print mode of an OpenSCAD model and saves the results to a new folder in the
renders directory, <model>-v<N>, all stamped with the same new version:

    <model>-v<N>/<model>-v<N>.stl             for render_mode "print"
    <model>-v<N>/<model>-<name>-v<N>.stl      for render_mode "print-<name>"
    <model>-v<N>/<model>-v<N>.3mf             for render_mode "print-3mf"
    <model>-v<N>/<model>-<name>-v<N>.3mf      for render_mode "print-3mf-<name>"

The print-3mf modes are for multi-color designs: they draw every part (body first,
then text), each in its own color(), and are exported as a 3MF with OpenSCAD's
lazy-union enabled so each part stays a separate object. Bambu Studio loads that as
one object with multiple parts. The STL modes never use lazy-union, which can change
geometry.

N is one more than the last version of this model, which is kept in a small file in the
renders directory, .build-versions.json, like { "kegerator-scales": 17 }. It lives with the
renders and not in git, so every worktree and branch shares one count, and moving or
archiving builds never changes the numbering. A model that isn't in the file yet is counted
once from what is on disk (build folders, loose files from before builds had folders, and
archive/<month>/), then recorded. Every run is a new version, numbers are never reused, and
existing files and folders are never overwritten. A lock keeps two builds from taking the
same number, and the number is only recorded once everything has rendered and been written.

A real build is refused while the model, or any file it includes or uses, has uncommitted changes (modified,
staged, or not added to git yet), so every version comes from a commit: commit first, then build. Other
changes in the worktree don't matter. A dry run skips this check, so it can be used to see what the next
version would be at any time. Pass --allow-uncommitted to build anyway.

Once a build is written, the commit it was made from is tagged with its version, like kegerator-scales-v23 (an
annotated tag, pushed like any other). A build with uncommitted changes isn't tagged, since the commit isn't what
it was made from. A tag that can't be made, because it already exists for example, is reported, and the build
stays.

A build is refused when nothing has changed since the last one: a fingerprint of the model, every
file it includes or uses, and the OpenSCAD version is kept with the version, and a build whose
fingerprint matches the last build's (whose folder is still there) stops before rendering anything.
Pass --force to build anyway.

Pass --dry-run to render everything (so failures still surface) without writing anything to
the output directory - useful for checking a model before committing it to a real version
number. A dry run of an unchanged model says so, and still renders.

Pass --reseed to count this model from the folders on disk again, if the version file is
ever lost or out of step (for example a build made by an older copy of this script).

If the model has a line like

    BUILD_SCRIPT_VERSION = "vXX";

the new version ("v<N>", matching the filenames) is passed in over it with -D while rendering,
so it can be used as a label on the part. Nothing is ever written into the .scad file, so in
the editor the label just reads "vXX", which is about as wide as a real version. Models without the line are built
as usual.

The render modes come from the model's settings block:

    render_mode = "preview";
    // render_mode = "print-bin";
    // render_mode = "print-text";

Configuration lives outside the repo (so every worktree shares it) in
~/.config/build-openscad/config.env:

    OUTPUT_DIR=/mnt/turbo-nas/general/3d-printing/_renders
    # OPENSCAD=/usr/bin/openscad-nightly      (optional)

The BUILD_OPENSCAD_OUTPUT_DIR environment variable overrides OUTPUT_DIR.
"""

import argparse
import contextlib
import fcntl
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

REPO_ROOT = Path( __file__ ).resolve().parent
CONFIG_PATH = Path.home() / ".config" / "build-openscad" / "config.env"
OUTPUT_EXTENSIONS = ( "stl", "3mf" )

# multi-color modes ("print-3mf" or "print-3mf-<name>"): every part in its own color, exported as a 3MF
MULTI_COLOR_MODE = "print-3mf"

# modules/ holds shared code and archive/ holds retired models - neither is ever built
EXCLUDED_DIRS = ( "modules", "archive" )

RENDER_MODE_PATTERN = re.compile( r'^\s*(?://\s*)?render_mode\s*=\s*"([^"]+)"\s*;', re.MULTILINE )

# the part after the version on a render file: the garden plant tags have -c0 and -c1 (body and text)
FILE_NAME_TEMPLATE = r"^%s(?:-.+)?-v(\d+)(?:-c\d+)?\.(?:%s)$"
FOLDER_NAME_TEMPLATE = r"^%s-v(\d+)$"

# the last version of every model, and the lock that keeps two builds from taking the same one
VERSIONS_FILE_NAME = ".build-versions.json"
LOCK_FILE_NAME = ".build-versions.lock"

# old builds are moved into archive/<month>/, and still count when numbering a model for the first time
ARCHIVE_DIR_NAME = "archive"

# the lines of a model that pull in other files, which a build depends on too
INCLUDE_PATTERN = re.compile( r'^\s*(?:include|use)\s*<([^>]+)>', re.MULTILINE )

# a model opts in to being given its version by defining this string, which the build passes in with -D
VERSION_VARIABLE = "BUILD_SCRIPT_VERSION"
VERSION_PATTERN = re.compile( r'^\s*' + VERSION_VARIABLE + r'\s*=\s*"[^"]*"', re.MULTILINE )

########################################################################################################################


def Fail( message ):
    sys.stdout.flush()
    print( "error: " + message, file = sys.stderr )
    sys.exit( 1 )

########################################################################################################################


def ReadConfig():
    config = {}
    if CONFIG_PATH.is_file():
        for line in CONFIG_PATH.read_text().splitlines():
            line = line.strip()
            if not line or line.startswith( "#" ) or "=" not in line:
                continue
            key, value = line.split( "=", 1 )
            config[ key.strip() ] = value.strip().strip( '"' ).strip( "'" )
    return config

########################################################################################################################


def FindOutputDir( config ):
    output_dir = os.environ.get( "BUILD_OPENSCAD_OUTPUT_DIR" ) or config.get( "OUTPUT_DIR" )
    if not output_dir:
        Fail(
            "no output directory configured.\n"
            "Create %s containing:\n"
            "    OUTPUT_DIR=/mnt/turbo-nas/general/3d-printing/_renders" % CONFIG_PATH )

    output_dir = Path( output_dir ).expanduser()
    if not output_dir.is_dir():
        Fail( "output directory does not exist (is the NAS mounted?): %s" % output_dir )
    return output_dir

########################################################################################################################


def FindOpenscad( config ):
    openscad = config.get( "OPENSCAD" ) or shutil.which( "openscad-nightly" ) or shutil.which( "openscad" )
    if not openscad:
        Fail( "could not find openscad-nightly or openscad on the PATH (or set OPENSCAD in %s)" % CONFIG_PATH )
    return openscad

########################################################################################################################


def CheckModelPath( model_path ):
    if not model_path.is_file():
        Fail( "file not found: %s" % model_path )
    if model_path.suffix != ".scad":
        Fail( "not an OpenSCAD file: %s" % model_path )

    try:
        relative = model_path.resolve().relative_to( REPO_ROOT )
    except ValueError:
        return
    if relative.parts[ 0 ] in EXCLUDED_DIRS:
        Fail( "%s is in %s/, which is never built" % ( model_path, relative.parts[ 0 ] ) )

########################################################################################################################


def FindPrintModes( model_path ):
    modes = []
    for mode in RENDER_MODE_PATTERN.findall( model_path.read_text() ):
        if mode not in modes:
            modes.append( mode )

    if not modes:
        Fail( "%s has no render_mode settings block" % model_path )

    print_modes = [ mode for mode in modes if mode == "print" or mode.startswith( "print-" ) ]
    if not print_modes:
        Fail( "%s has no print modes (found: %s)" % ( model_path, ", ".join( modes ) ) )
    return print_modes

########################################################################################################################


def IsMultiColorMode( mode ):
    return mode == MULTI_COLOR_MODE or mode.startswith( MULTI_COLOR_MODE + "-" )

########################################################################################################################


def VersionLabel( version ):
    return "v%d" % version

########################################################################################################################


def HasVersionVariable( model_path ):
    with open( model_path, newline = "" ) as model_file:
        return VERSION_PATTERN.search( model_file.read() ) is not None

########################################################################################################################

########################################################################################################################


def BuildFolderName( model_name, version ):
    return "%s-%s" % ( model_name, VersionLabel( version ) )

########################################################################################################################


def OutputName( model_name, mode, version ):
    if IsMultiColorMode( mode ):
        # the extension already says 3mf: print-3mf -> <model>-v<N>.3mf, print-3mf-<name> -> <model>-<name>-v<N>.3mf
        suffix = mode[ len( MULTI_COLOR_MODE ): ]
        return "%s%s-%s.3mf" % ( model_name, suffix, VersionLabel( version ) )
    suffix = "" if mode == "print" else "-" + mode[ len( "print-" ): ]
    extension = "stl"
    return "%s%s-%s.%s" % ( model_name, suffix, VersionLabel( version ), extension )

########################################################################################################################


def WorktreeRoots():
    """The root of every worktree of this repo. Models live on different branches, so render files and
    folders can belong to a model that isn't in the worktree being built."""
    try:
        result = subprocess.run(
            [ "git", "-C", str( REPO_ROOT ), "worktree", "list", "--porcelain" ],
            capture_output = True, text = True, check = True )
    except ( OSError, subprocess.CalledProcessError ):
        return [ REPO_ROOT ]

    prefix = "worktree "
    roots = [ Path( line[ len( prefix ): ] ) for line in result.stdout.splitlines() if line.startswith( prefix ) ]
    return roots or [ REPO_ROOT ]

########################################################################################################################


def ModelNames( extra_names = () ):
    """The name of every model in every worktree, which render files and folders are named after."""
    names = set( extra_names )
    for root in WorktreeRoots():
        names |= { path.stem for path in root.rglob( "*.scad" ) }
    return names

########################################################################################################################


def FilePatterns( model_names ):
    extensions = "|".join( OUTPUT_EXTENSIONS )
    return { name: re.compile( FILE_NAME_TEMPLATE % ( re.escape( name ), extensions ) ) for name in model_names }

########################################################################################################################


def FolderPatterns( model_names ):
    return { name: re.compile( FOLDER_NAME_TEMPLATE % re.escape( name ) ) for name in model_names }

########################################################################################################################


def FindBuild( name, patterns ):
    """Returns ( model name, version ) for a render file or build folder name, or None if it is neither.

    Model names can be prefixes of each other (gridfinity-tape-measures vs gridfinity-tape-measures-single),
    so each name is attributed to the longest model name that matches it.
    """
    matches = []
    for model_name, pattern in patterns.items():
        match = pattern.match( name )
        if match:
            matches.append( ( len( model_name ), model_name, int( match.group( 1 ) ) ) )
    if not matches:
        return None
    _, model_name, version = max( matches )
    return model_name, version

########################################################################################################################


def BuildEntries( output_dir ):
    """Every build folder and render file in the renders directory, including those in archive/<month>/."""
    for path in output_dir.iterdir():
        if path.name == ARCHIVE_DIR_NAME and path.is_dir():
            for month in path.iterdir():
                if month.is_dir():
                    yield from month.iterdir()
        else:
            yield path

########################################################################################################################


def FindHighestVersion( model_name, output_dir ):
    """The highest version of this model on disk, or -1 if there are none.

    Counts build folders (<model>-v<N>) and loose render files from before builds had folders, in the renders
    directory and in archive/<month>/. Only used for a model that isn't in the version file yet, and by --reseed.
    """
    model_names = ModelNames() | { model_name }
    file_patterns = FilePatterns( model_names )
    folder_patterns = FolderPatterns( model_names )

    highest = -1
    for path in BuildEntries( output_dir ):
        patterns = folder_patterns if path.is_dir() else file_patterns
        build = FindBuild( path.name, patterns )
        if build and build[ 0 ] == model_name:
            highest = max( highest, build[ 1 ] )
    return highest

########################################################################################################################


def BuildRecord( version, inputs = None, commit = None ):
    """What is kept about a model's last build: its version, the fingerprint of its inputs, when it was built,
    and the branch and commit it was built from."""
    record = { "version": version, "inputs": inputs, "built": time.strftime( "%Y-%m-%d %H:%M" ) }
    record.update( commit or {} )
    return record

########################################################################################################################


def ReadVersions( output_dir ):
    """The last build of every model, from the version file ( {} if there isn't one yet ).

    A bare number, as an earlier copy of this script wrote, is read as a build with no fingerprint.
    """
    path = output_dir / VERSIONS_FILE_NAME
    if not path.is_file():
        return {}

    try:
        versions = json.loads( path.read_text() )
        if not isinstance( versions, dict ):
            raise ValueError( "not a list of models" )
        for model_name, record in list( versions.items() ):
            if isinstance( record, int ):
                versions[ model_name ] = { "version": record, "inputs": None, "built": None }
            elif not isinstance( record, dict ) or not isinstance( record.get( "version" ), int ):
                raise ValueError( "no version for %s" % model_name )
    except ValueError:
        Fail(
            "%s is not a valid version file, so it was left alone.\n"
            "Fix it by hand, or delete it: the next build of each model then counts from the folders." % path )
    return versions

########################################################################################################################


def WriteVersions( output_dir, versions ):
    path = output_dir / VERSIONS_FILE_NAME
    temp_path = path.with_name( path.name + ".tmp" )
    temp_path.write_text( json.dumps( versions, indent = 2, sort_keys = True ) + "\n" )
    os.replace( temp_path, path )

########################################################################################################################


def NextVersion( model_name, output_dir, versions ):
    """One more than the model's last version: from the version file, or counted from disk the first time."""
    if model_name in versions:
        return versions[ model_name ][ "version" ] + 1
    return FindHighestVersion( model_name, output_dir ) + 1

########################################################################################################################


class BuildLock:
    """Held for a whole build, so two builds can't take the same version number. Released if the build dies."""

    def __init__( self, output_dir ):
        self.path = output_dir / LOCK_FILE_NAME
        self.file = None

    def __enter__( self ):
        self.file = open( self.path, "a" )
        try:
            fcntl.flock( self.file, fcntl.LOCK_EX | fcntl.LOCK_NB )
        except BlockingIOError:
            print( "waiting for another build to finish..." )
            fcntl.flock( self.file, fcntl.LOCK_EX )
        except OSError:
            print( "note: this file system doesn't support locking, so builds can't be kept from overlapping" )
        return self

    def __exit__( self, *exception_info ):
        self.file.close()

########################################################################################################################


def OpenscadVersion( openscad ):
    result = subprocess.run( [ openscad, "--version" ], capture_output = True, text = True )
    return ( result.stdout + result.stderr ).strip()

########################################################################################################################


def LibraryDirs():
    """Where OpenSCAD looks for libraries that a model includes or uses."""
    dirs = [ Path( path ) for path in os.environ.get( "OPENSCADPATH", "" ).split( os.pathsep ) if path ]
    user_libraries = Path.home() / ".local" / "share" / "OpenSCAD" / "libraries"
    return dirs + [ user_libraries, Path( "/usr/share/openscad/libraries" ) ]

########################################################################################################################


def FindInputFiles( model_path ):
    """The model and every file it includes or uses, found by following those lines down through the files
    they include. Returns { path: content }."""
    files = {}
    pending = [ model_path.resolve() ]
    while pending:
        path = pending.pop()
        if path in files:
            continue
        files[ path ] = path.read_bytes()

        for name in INCLUDE_PATTERN.findall( files[ path ].decode( "utf-8", errors = "replace" ) ):
            for base in [ path.parent ] + LibraryDirs():
                if ( base / name ).is_file():
                    pending.append( ( base / name ).resolve() )
                    break
    return files

########################################################################################################################


def HashInputs( files, openscad, extra = "" ):
    """A fingerprint of everything a build depends on: the files from FindInputFiles, the OpenSCAD version, and
    anything else passed in. Only the content counts and not where the files are, so the same code in two
    worktrees matches."""
    def Label( path ):
        for root in [ REPO_ROOT ] + LibraryDirs():
            try:
                return str( path.relative_to( root.resolve() ) )
            except ValueError:
                pass
        return path.name

    digest = hashlib.sha256()
    digest.update( OpenscadVersion( openscad ).encode() )
    digest.update( extra.encode() )
    for label, content in sorted( ( Label( path ), content ) for path, content in files.items() ):
        digest.update( label.encode() )
        digest.update( content )
    return digest.hexdigest()

########################################################################################################################


def Git( directory, *arguments ):
    """The output of a git command run in the directory, or None if it failed (or this isn't a git repository)."""
    result = subprocess.run( [ "git", "-C", str( directory ) ] + list( arguments ), capture_output = True, text = True )
    return result.stdout.strip() if result.returncode == 0 else None

########################################################################################################################


def UncommittedFiles( paths ):
    """The paths that have uncommitted changes in git: modified, staged, or not added yet. Paths outside a git
    repository are never reported."""
    changed = []
    for path in paths:
        top = Git( path.parent, "rev-parse", "--show-toplevel" )
        if not top:
            continue
        status = Git( top, "status", "--porcelain", "--", str( path ) )
        if status:
            changed.append( path.name )
    return sorted( changed )

########################################################################################################################


def CurrentCommit( model_path ):
    """The branch and commit a build is made from, or None outside a git repository."""
    commit = Git( model_path.resolve().parent, "rev-parse", "HEAD" )
    if not commit:
        return None
    return { "branch": Git( model_path.resolve().parent, "rev-parse", "--abbrev-ref", "HEAD" ), "commit": commit }

########################################################################################################################


def TagBuild( model_path, tag_name ):
    """Tags the commit the model is at with the build's version. Returns what happened, to print, since a tag that
    can't be made never undoes a build that has already been written."""
    directory = model_path.resolve().parent
    if not Git( directory, "rev-parse", "HEAD" ):
        return "not tagged, because %s isn't in a git repository" % model_path.name
    if Git( directory, "tag", "--annotate", "--message", tag_name, tag_name ) is None:
        return "could not tag the commit %s (does the tag already exist?)" % tag_name
    return "tagged the commit %s" % tag_name

########################################################################################################################


def BuildExists( output_dir, folder_name ):
    return any( path.name == folder_name for path in BuildEntries( output_dir ) )

########################################################################################################################


def UnchangedSince( model_name, output_dir, versions, inputs ):
    """The version of the last build if nothing has changed since it (and its folder is still there), else None."""
    last = versions.get( model_name )
    if not last or last.get( "inputs" ) != inputs:
        return None
    if not BuildExists( output_dir, BuildFolderName( model_name, last[ "version" ] ) ):
        return None
    return last[ "version" ]

########################################################################################################################


def Render( openscad, model_path, mode, output_path, version_label = None ):
    command = [ openscad ]
    if IsMultiColorMode( mode ):
        command.append( "--enable=lazy-union" )
    if version_label:
        command += [ "-D", '%s="%s"' % ( VERSION_VARIABLE, version_label ) ]
    command += [
        "-D", 'render_mode="%s"' % mode,
        "-o", str( output_path ),
        str( model_path ) ]

    start = time.monotonic()
    result = subprocess.run( command, capture_output = True, text = True )
    elapsed = time.monotonic() - start

    messages = [ line for line in result.stderr.splitlines() if line.startswith( ( "WARNING", "ERROR" ) ) ]
    succeeded = result.returncode == 0 and output_path.is_file() and output_path.stat().st_size > 0
    return succeeded, elapsed, messages, result.stderr

########################################################################################################################


def Reseed( model_name, output_dir ):
    """Counts the model's last version from the folders on disk again, and records it."""
    with BuildLock( output_dir ):
        versions = ReadVersions( output_dir )
        highest = FindHighestVersion( model_name, output_dir )
        if highest < 0:
            versions.pop( model_name, None )
            print( "%s: no builds found on disk, so the next build will be %s" % ( model_name, VersionLabel( 0 ) ) )
        else:
            versions[ model_name ] = BuildRecord( highest )
            print(
                "%s: the last version is now %s, so the next build will be %s"
                % ( model_name, VersionLabel( highest ), VersionLabel( highest + 1 ) ) )
        WriteVersions( output_dir, versions )

########################################################################################################################


def CheckBuildIsWanted( dry_run, force, allow_uncommitted, model_name, output_dir, versions, files, inputs ):
    """Stops a real build when the code isn't committed, or when nothing has changed since the last build. A
    dry run never checks for uncommitted changes, and only says if nothing has changed, then carries on."""
    problems = []

    uncommitted = [] if allow_uncommitted or dry_run else UncommittedFiles( files )
    if uncommitted:
        problems.append(
            "these files have uncommitted changes: %s\n"
            "Commit them first, then build, so this version comes from a commit.\n"
            "(--allow-uncommitted builds anyway)" % ", ".join( uncommitted ) )
    elif not force:
        unchanged = UnchangedSince( model_name, output_dir, versions, inputs )
        if unchanged is not None:
            built = versions[ model_name ].get( "built" )
            problems.append(
                "nothing has changed since %s was built%s, so there is nothing new to build.\n"
                "(--force builds anyway)" % ( VersionLabel( unchanged ), " on " + built if built else "" ) )

    for problem in problems:
        if dry_run:
            print( "[dry-run] note: a real build would stop here: " + problem )
        else:
            sys.stdout.flush()
            print( "not building: " + problem, file = sys.stderr )
            sys.exit( 1 )


########################################################################################################################


def Build( dry_run, force, allow_uncommitted, model_path, model_name, print_modes, output_dir, openscad ):
    versions = ReadVersions( output_dir )
    files = FindInputFiles( model_path )
    inputs = HashInputs( files, openscad )
    CheckBuildIsWanted( dry_run, force, allow_uncommitted, model_name, output_dir, versions, files, inputs )

    version = NextVersion( model_name, output_dir, versions )
    build_dir = output_dir / BuildFolderName( model_name, version )
    targets = [ ( mode, build_dir / OutputName( model_name, mode, version ) ) for mode in print_modes ]

    if build_dir.exists():
        Fail(
            "%s already exists, so the version file is out of step with the folders.\n"
            "Run this again with --reseed to count this model from the folders again." % build_dir )

    # only models that define the version string are given it
    has_version_variable = HasVersionVariable( model_path )
    version_label = VersionLabel( version ) if has_version_variable else None

    dry_run_prefix = "[dry-run] " if dry_run else ""
    print( "%s%s %s:" % ( dry_run_prefix, "Would build" if dry_run else "Building", VersionLabel( version ) ) )

    # render everything to a temporary directory first, so a failure never leaves a partial version behind
    with tempfile.TemporaryDirectory( prefix = "build-openscad-" ) as temp_dir:
        rendered = []
        for mode, target in targets:
            temp_path = Path( temp_dir ) / target.name
            succeeded, elapsed, messages, stderr = Render( openscad, model_path, mode, temp_path, version_label )

            print( "  %-32s %6.1fs  %s" % ( mode, elapsed, "ok" if succeeded else "FAILED" ) )
            for message in messages:
                print( "      " + message )

            if not succeeded:
                if not messages:
                    print( stderr )
                Fail( "render of %s failed - nothing was written" % mode )
            rendered.append( ( temp_path, target ) )

        if not dry_run:
            build_dir.mkdir()
            try:
                for temp_path, target in rendered:
                    with open( temp_path, "rb" ) as source, open( target, "xb" ) as destination:
                        shutil.copyfileobj( source, destination )

                # the version is only recorded once everything is written, so a failed build never uses up a number
                versions[ model_name ] = BuildRecord( version, inputs, CurrentCommit( model_path ) )
                WriteVersions( output_dir, versions )
            except BaseException:
                # the folder was just made by this run, so a half-written version is removed with it
                shutil.rmtree( build_dir )
                raise

    # the tag has the same name as the build folder, like kegerator-scales-v23
    tag_name = BuildFolderName( model_name, version )
    if dry_run:
        tag_message = "would tag the commit %s" % tag_name
    elif UncommittedFiles( files ):
        tag_message = "not tagged, because it was built with uncommitted changes"
    else:
        tag_message = TagBuild( model_path, tag_name )

    print()
    verb = "would write" if dry_run else "wrote"
    for _, target in rendered:
        print( "  %s %s" % ( verb, target.name ) )
    print( "  in %s" % build_dir )
    if has_version_variable:
        print(
            '  %s = "%s" %s the renders (the .scad file is not changed)'
            % ( VERSION_VARIABLE, VersionLabel( version ), "would be passed to" if dry_run else "was passed to" ) )
    print( "  " + tag_message )
    print()
    print( "%sversion: %s %s" % ( dry_run_prefix, model_name, VersionLabel( version ) ) )

########################################################################################################################


def main():
    parser = argparse.ArgumentParser(
        description = "Render every print mode of an OpenSCAD model into a new, versioned folder." )
    parser.add_argument( "model", help = "path to the .scad file, e.g. gridfinity/gridfinity-ruler-bin.scad" )
    parser.add_argument(
        "--dry-run", action = "store_true",
        help = "render everything to verify it works, but don't write anything to the output directory" )
    parser.add_argument(
        "--force", action = "store_true",
        help = "build even if nothing has changed since the last build" )
    parser.add_argument(
        "--allow-uncommitted", action = "store_true",
        help = "build even if the model or a file it includes has uncommitted changes" )
    parser.add_argument(
        "--reseed", action = "store_true",
        help = "count this model's last version from the folders on disk again, record it, and stop" )
    args = parser.parse_args()

    model_path = Path( args.model )
    CheckModelPath( model_path )
    print_modes = FindPrintModes( model_path )

    config = ReadConfig()
    output_dir = FindOutputDir( config )
    openscad = FindOpenscad( config )
    model_name = model_path.stem

    if args.reseed:
        Reseed( model_name, output_dir )
        return

    # a dry run only reads the version file, so it doesn't take the lock
    lock = contextlib.nullcontext() if args.dry_run else BuildLock( output_dir )
    with lock:
        Build(
            args.dry_run, args.force, args.allow_uncommitted, model_path, model_name, print_modes, output_dir,
            openscad )

########################################################################################################################


if __name__ == "__main__":
    main()
