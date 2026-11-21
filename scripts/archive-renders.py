#!/usr/bin/env python3
"""
archive-renders.py [--days N] [--apply] [--show-all]
archive-renders.py --undo <manifest> [--apply]

Moves old renders out of the main renders folder into one folder per month:

    kegerator-scales-v12/                 ->  archive/2026-08/kegerator-scales-v12/
    ams-shelf-v10-shelf-a.stl             ->  archive/2026-08/ams-shelf-v10-shelf-a.stl

Build folders (<name>-v<N>) move whole, and any loose file moves as it is, still loose. The month is
when the file, or the newest file in the folder, was last modified. Everything older than --days
(60 by default) goes, including the newest build of a model: the version file keeps the numbering,
so nothing is lost by archiving, and build-openscad.py still looks in archive/ when it checks whether
anything has changed since the last build.

Left alone: hidden files (the version file and its lock), the archive folder itself, and any folder
that isn't a build folder. Nothing is ever overwritten, renamed or deleted.

Without --apply it only lists what it would do. With --apply every move is recorded in a manifest in
~/.config/build-openscad/, and --undo <manifest> moves everything back (also a dry run unless --apply
is given), removing any month folder that ends up empty.

The output directory comes from the same configuration as build-openscad.py.
"""

import argparse
import importlib.util
import re
import sys
import time
from pathlib import Path

REPO_ROOT = Path( __file__ ).resolve().parent.parent
MANIFEST_DIRECTORY = Path.home() / ".config" / "build-openscad"

# renders older than this are archived, unless --days says otherwise
DEFAULT_DAYS = 60

# a folder is a build folder if it is named like <model>-v<N>
BUILD_FOLDER_PATTERN = re.compile( r"-v\d+$" )

SECONDS_PER_DAY = 24 * 60 * 60

# how many of the files and folders left alone to list, unless --show-all is given
LEFT_ALONE_PREVIEW_COUNT = 12

########################################################################################################################


def LoadBuildScript():
    """build-openscad.py, for its configuration, the archive folder name and the build lock."""
    spec = importlib.util.spec_from_file_location( "build_openscad", REPO_ROOT / "build-openscad.py" )
    module = importlib.util.module_from_spec( spec )
    spec.loader.exec_module( module )
    return module

########################################################################################################################


def LastModified( path ):
    """When the file was last modified, or for a folder the newest modification of anything in it."""
    if not path.is_dir():
        return path.stat().st_mtime
    times = [ child.stat().st_mtime for child in path.rglob( "*" ) ]
    return max( times, default = path.stat().st_mtime )

########################################################################################################################


def PlanMoves( build, output_dir, days ):
    """Returns ( moves, left_alone, kept ). moves is a list of ( source, destination ), left_alone the names
    that are never archived, and kept the number of renders that are too new."""
    archive_dir = output_dir / build.ARCHIVE_DIR_NAME
    cutoff = time.time() - days * SECONDS_PER_DAY

    moves = []
    left_alone = []
    kept = 0
    for path in sorted( output_dir.iterdir() ):
        if path.name.startswith( "." ) or path.name == build.ARCHIVE_DIR_NAME:
            continue
        if path.is_dir() and not BUILD_FOLDER_PATTERN.search( path.name ):
            left_alone.append( path.name + "/" )
            continue

        modified = LastModified( path )
        if modified >= cutoff:
            kept += 1
            continue
        month = time.strftime( "%Y-%m", time.localtime( modified ) )
        moves.append( ( path, archive_dir / month / path.name ) )
    return moves, left_alone, kept

########################################################################################################################


def Summarize( moves, left_alone, kept, days, show_all ):
    months = {}
    for source, destination in moves:
        months.setdefault( destination.parent.name, [] ).append( source )

    for month, sources in sorted( months.items() ):
        folders = sum( 1 for source in sources if source.is_dir() )
        print( "  archive/%s/  %4d folders, %4d files" % ( month, folders, len( sources ) - folders ) )

    print()
    print( "%d items to archive (older than %d days), %d newer ones stay" % ( len( moves ), days, kept ) )
    if left_alone:
        print( "%d left alone (not build folders)" % len( left_alone ) )
        listed = left_alone if show_all else left_alone[ :LEFT_ALONE_PREVIEW_COUNT ]
        for name in listed:
            print( "    " + name )
        if len( listed ) < len( left_alone ):
            print( "    ... and %d more (--show-all lists them all)" % ( len( left_alone ) - len( listed ) ) )

########################################################################################################################


def Apply( build, moves, output_dir ):
    conflicts = [ destination for _, destination in moves if destination.exists() ]
    if conflicts:
        print( "error: refusing to overwrite existing files, nothing was moved:", file = sys.stderr )
        for destination in conflicts[ :10 ]:
            print( "    " + str( destination ), file = sys.stderr )
        sys.exit( 1 )

    MANIFEST_DIRECTORY.mkdir( parents = True, exist_ok = True )
    manifest_path = MANIFEST_DIRECTORY / time.strftime( "archive-renders-%Y%m%d-%H%M%S.tsv" )

    # held so a build can't start in the middle of the move, and be told a folder isn't there
    with build.BuildLock( output_dir ):
        moved = 0
        with open( manifest_path, "x" ) as manifest:
            manifest.write( "# archive-renders.py: source <tab> destination, one move per line\n" )
            for source, destination in moves:
                destination.parent.mkdir( parents = True, exist_ok = True )

                # recorded first, so the manifest never misses a move that happened
                manifest.write( "%s\t%s\n" % ( source, destination ) )
                manifest.flush()
                source.rename( destination )
                moved += 1

    print( "moved %d items, recorded in %s" % ( moved, manifest_path ) )
    print( "to put everything back: archive-renders.py --undo %s --apply" % manifest_path )

########################################################################################################################


def Undo( manifest_path, apply ):
    moves = []
    for line in manifest_path.read_text().splitlines():
        if line and not line.startswith( "#" ):
            source, destination = line.split( "\t" )
            moves.append( ( Path( source ), Path( destination ) ) )

    problems = [ ( s, d ) for s, d in moves if not d.exists() or s.exists() ]
    for source, destination in problems[ :10 ]:
        print( "  cannot put back %s (it is missing, or something is already at %s)" % ( destination.name, source ) )

    todo = [ ( s, d ) for s, d in moves if d.exists() and not s.exists() ]
    print( "%s%d of %d items can be put back" % ( "" if apply else "[dry-run] ", len( todo ), len( moves ) ) )
    if not apply:
        return

    month_folders = set()
    for source, destination in todo:
        destination.rename( source )
        month_folders.add( destination.parent )

    removed = 0
    for folder in month_folders:
        if folder.is_dir() and not any( folder.iterdir() ):
            folder.rmdir()
            removed += 1
    print( "put back %d items, removed %d empty month folders" % ( len( todo ), removed ) )

########################################################################################################################


def main():
    parser = argparse.ArgumentParser( description = "Move old renders into archive/<year-month>/." )
    parser.add_argument(
        "--days", type = int, default = DEFAULT_DAYS,
        help = "archive renders last modified more than this many days ago (default %d)" % DEFAULT_DAYS )
    parser.add_argument( "--apply", action = "store_true", help = "actually move them (otherwise only list them)" )
    parser.add_argument( "--show-all", action = "store_true", help = "list every item that is left alone" )
    parser.add_argument( "--undo", metavar = "MANIFEST", type = Path, help = "put back what a previous --apply moved" )
    args = parser.parse_args()

    if args.undo:
        if not args.undo.is_file():
            print( "error: manifest not found: %s" % args.undo, file = sys.stderr )
            sys.exit( 1 )
        Undo( args.undo, args.apply )
        return

    build = LoadBuildScript()
    output_dir = build.FindOutputDir( build.ReadConfig() )

    moves, left_alone, kept = PlanMoves( build, output_dir, args.days )
    print( "%s%s:" % ( "" if args.apply else "[dry-run] ", output_dir ) )
    Summarize( moves, left_alone, kept, args.days, args.show_all )

    if not moves:
        return
    print()
    if args.apply:
        Apply( build, moves, output_dir )
    else:
        print( "[dry-run] nothing was moved. run again with --apply to move them" )

########################################################################################################################


if __name__ == "__main__":
    main()
