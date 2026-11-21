#!/usr/bin/env python3
"""
organize-renders.py [--apply] [--show-skipped]
organize-renders.py --undo <manifest> [--apply]

One-time tidy of the renders directory. Before builds had folders, every render was a loose file:

    kegerator-scales-keg-1-base-v15.stl

This moves the loose files of each build into a folder of its own, the way build-openscad.py now
writes them:

    kegerator-scales-v15/kegerator-scales-keg-1-base-v15.stl

Only files that can be positively identified are moved: a file name has to end in -v<N>.stl or
-v<N>.3mf and start with the name of a model in any worktree of this repo (or the garden plant tags).
Anything else, such as older naming (ams-shelf-v10-shelf-a.stl) or renders of models that no longer
exist, is left exactly where it is. Nothing is ever overwritten, renamed or deleted, and file names
don't change.

Without --apply it only lists what it would do. With --apply every move is recorded in a manifest
in ~/.config/build-openscad/, and --undo <manifest> moves everything back (also a dry run unless
--apply is given), removing any folder that ends up empty.

The output directory comes from the same configuration as build-openscad.py.
"""

import argparse
import importlib.util
import sys
import time
from pathlib import Path

REPO_ROOT = Path( __file__ ).resolve().parent.parent
MANIFEST_DIRECTORY = Path.home() / ".config" / "build-openscad"

# renders named after something other than a .scad file: generate-garden-labels.py writes
# garden-plant-tag-<plant>-<variety>-<orientation>-v<N>-c0.stl from garden-plant-tags.scad
EXTRA_MODEL_NAMES = ( "garden-plant-tag", )

# how many of the skipped files to list, unless --show-skipped is given
SKIPPED_PREVIEW_COUNT = 12

########################################################################################################################


def LoadBuildScript():
    """build-openscad.py, for its configuration and for the file and folder naming, which must stay the same."""
    spec = importlib.util.spec_from_file_location( "build_openscad", REPO_ROOT / "build-openscad.py" )
    module = importlib.util.module_from_spec( spec )
    spec.loader.exec_module( module )
    return module

########################################################################################################################


def PlanMoves( build, output_dir ):
    """Returns ( moves, skipped ). moves is a list of ( source, destination ), skipped the names left alone."""
    file_patterns = build.FilePatterns( build.ModelNames( EXTRA_MODEL_NAMES ) )

    moves = []
    skipped = []
    for path in sorted( output_dir.iterdir() ):
        if path.is_dir():
            continue

        found = build.FindBuild( path.name, file_patterns )
        if not found:
            skipped.append( path.name )
            continue

        model_name, version = found
        moves.append( ( path, output_dir / build.BuildFolderName( model_name, version ) / path.name ) )
    return moves, skipped

########################################################################################################################


def Summarize( moves, skipped, show_skipped ):
    folders = {}
    for source, destination in moves:
        folders.setdefault( destination.parent.name, [] ).append( source.name )

    for folder, names in sorted( folders.items() ):
        print( "  %-52s %3d files" % ( folder + "/", len( names ) ) )

    print()
    print( "%d files into %d folders" % ( len( moves ), len( folders ) ) )
    print( "%d files left alone (not recognized as a build of a model in any worktree)" % len( skipped ) )

    listed = skipped if show_skipped else skipped[ :SKIPPED_PREVIEW_COUNT ]
    for name in listed:
        print( "    " + name )
    if len( listed ) < len( skipped ):
        print( "    ... and %d more (--show-skipped lists them all)" % ( len( skipped ) - len( listed ) ) )

########################################################################################################################


def Apply( moves, output_dir ):
    conflicts = [ destination for _, destination in moves if destination.exists() ]
    if conflicts:
        print( "error: refusing to overwrite existing files, nothing was moved:", file = sys.stderr )
        for destination in conflicts[ :10 ]:
            print( "    " + str( destination ), file = sys.stderr )
        sys.exit( 1 )

    MANIFEST_DIRECTORY.mkdir( parents = True, exist_ok = True )
    manifest_path = MANIFEST_DIRECTORY / time.strftime( "organize-renders-%Y%m%d-%H%M%S.tsv" )

    moved = 0
    with open( manifest_path, "x" ) as manifest:
        manifest.write( "# organize-renders.py: source <tab> destination, one move per line\n" )
        for source, destination in moves:
            destination.parent.mkdir( exist_ok = True )

            # recorded first, so the manifest never misses a move that happened
            manifest.write( "%s\t%s\n" % ( source, destination ) )
            manifest.flush()
            source.rename( destination )
            moved += 1

    print( "moved %d files, recorded in %s" % ( moved, manifest_path ) )
    print( "to put everything back: organize-renders.py --undo %s --apply" % manifest_path )

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
    print( "%s%d of %d files can be put back" % ( "" if apply else "[dry-run] ", len( todo ), len( moves ) ) )
    if not apply:
        return

    folders = set()
    for source, destination in todo:
        destination.rename( source )
        folders.add( destination.parent )

    removed = 0
    for folder in folders:
        if folder.is_dir() and not any( folder.iterdir() ):
            folder.rmdir()
            removed += 1
    print( "put back %d files, removed %d empty folders" % ( len( todo ), removed ) )

########################################################################################################################


def main():
    parser = argparse.ArgumentParser( description = "Move the loose render files of each build into its own folder." )
    parser.add_argument( "--apply", action = "store_true", help = "actually move the files (otherwise only list them)" )
    parser.add_argument( "--show-skipped", action = "store_true", help = "list every file that is left alone" )
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

    moves, skipped = PlanMoves( build, output_dir )
    print( "%s%s:" % ( "" if args.apply else "[dry-run] ", output_dir ) )
    Summarize( moves, skipped, args.show_skipped )

    if not moves:
        return
    print()
    if args.apply:
        Apply( moves, output_dir )
    else:
        print( "[dry-run] nothing was moved. run again with --apply to move them" )

########################################################################################################################


if __name__ == "__main__":
    main()
