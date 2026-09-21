#!/usr/bin/env python3
"""
build-openscad.py <model.scad>

Renders every print mode ("print" and "print-*") of an OpenSCAD model to STL and
saves them to the renders directory, all stamped with the same new version:

    <model>-v<N>.stl             for render_mode "print"
    <model>-<name>-v<N>.stl      for render_mode "print-<name>"

N is one more than the highest version of this model already in the renders
directory (v0 if there are none), so every run is a new version and parts of a
multi-part design always line up. Existing files are never overwritten.

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

# modules/ holds shared code and archive/ holds retired models - neither is ever built
EXCLUDED_DIRS = ( "modules", "archive" )

RENDER_MODE_PATTERN = re.compile( r'^\s*(?://\s*)?render_mode\s*=\s*"([^"]+)"\s*;', re.MULTILINE )

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


def OutputName( model_name, mode, version, extension = "stl" ):
    suffix = "" if mode == "print" else "-" + mode[ len( "print-" ): ]
    return "%s%s-v%d.%s" % ( model_name, suffix, version, extension )

########################################################################################################################


def FindNextVersion( model_name, output_dir ):
    """One more than the highest existing version of this model, or 0 if there are none.

    Model names can be prefixes of each other (gridfinity-tape-measures vs gridfinity-tape-measures-single),
    so each render file is attributed to the longest model name that matches it.
    """
    model_names = { path.stem for path in REPO_ROOT.rglob( "*.scad" ) }
    model_names.add( model_name )

    extensions = "|".join( OUTPUT_EXTENSIONS )
    patterns = {
        name: re.compile( r"^%s(?:-.+)?-v(\d+)\.(?:%s)$" % ( re.escape( name ), extensions ) )
        for name in model_names }

    highest = -1
    for path in output_dir.iterdir():
        matches = [ ( len( name ), name, pattern.match( path.name ) ) for name, pattern in patterns.items() ]
        matches = [ match for match in matches if match[ 2 ] ]
        if not matches:
            continue
        _, owner, match = max( matches, key = lambda match: match[ 0 ] )
        if owner == model_name:
            highest = max( highest, int( match.group( 1 ) ) )
    return highest + 1

########################################################################################################################


def Render( openscad, model_path, mode, output_path ):
    command = [
        openscad,
        "--enable=textmetrics",
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


def main():
    parser = argparse.ArgumentParser(
        description = "Render every print mode of an OpenSCAD model to a new, versioned set of STL files." )
    parser.add_argument( "model", help = "path to the .scad file, e.g. gridfinity/gridfinity-ruler-bin.scad" )
    args = parser.parse_args()

    model_path = Path( args.model )
    CheckModelPath( model_path )
    print_modes = FindPrintModes( model_path )

    config = ReadConfig()
    output_dir = FindOutputDir( config )
    openscad = FindOpenscad( config )

    model_name = model_path.stem
    version = FindNextVersion( model_name, output_dir )
    targets = [ ( mode, output_dir / OutputName( model_name, mode, version ) ) for mode in print_modes ]

    for _, target in targets:
        if target.exists():
            Fail( "refusing to overwrite existing file: %s" % target )

    print( "%s v%d: rendering %d print mode(s) into %s" % ( model_name, version, len( targets ), output_dir ) )

    # render everything to a temporary directory first, so a failure never leaves a partial version behind
    with tempfile.TemporaryDirectory( prefix = "build-openscad-" ) as temp_dir:
        rendered = []
        for mode, target in targets:
            temp_path = Path( temp_dir ) / target.name
            succeeded, elapsed, messages, stderr = Render( openscad, model_path, mode, temp_path )

            print( "  %-32s %6.1fs  %s" % ( mode, elapsed, "ok" if succeeded else "FAILED" ) )
            for message in messages:
                print( "      " + message )

            if not succeeded:
                if not messages:
                    print( stderr )
                Fail( "render of %s failed - nothing was written" % mode )
            rendered.append( ( temp_path, target ) )

        for temp_path, target in rendered:
            with open( temp_path, "rb" ) as source, open( target, "xb" ) as destination:
                shutil.copyfileobj( source, destination )

    print()
    for _, target in rendered:
        print( "  wrote %s" % target.name )
    print()
    print( "version: %s v%d" % ( model_name, version ) )

########################################################################################################################


if __name__ == "__main__":
    main()
