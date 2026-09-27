#!/usr/bin/env python3
"""
generate-combined-scad.py <model.scad>

Produces a single, self-contained .scad file for sharing a model without the rest of
this repo. Every `include <...>` / `use <...>` of a module that lives in this repo is
inlined (recursively - modules that pull in other modules are backtraced and inlined
too), so the result has no dependency on anything under modules/. A module is only
ever inlined once, no matter how many places reference it.

References to things that are NOT in this repo (a 3rd-party library, or an
OPENSCADPATH library like MCAD) are left completely untouched - their code is never
copied in, per request.

References to in-repo files that aren't .scad (fonts used via `use <...>`, and STL/SVG
parts pulled in with import(...)) are kept as external files rather than inlined, but
their paths are rewritten so they still resolve correctly from the combined/ directory
(assets/ itself is not touched or copied - the combined file just points back at it).

The combined file is written to combined/<model>.scad. Every print mode declared in
its settings block (see build-openscad.py for the render_mode convention) is then
rendered to combined/<model>[-<name>].stl (or .3mf for multi-color "print-3mf" modes),
the same way build-openscad.py does for the full repo.
"""

import argparse
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path( __file__ ).resolve().parent
COMBINED_DIR = REPO_ROOT / "combined"

RENDER_MODE_PATTERN = re.compile( r'^\s*(?://\s*)?render_mode\s*=\s*"([^"]+)"\s*;', re.MULTILINE )
DIRECTIVE_PATTERN = re.compile( r'^([ \t]*)(include|use)([ \t]*<[ \t]*)([^>]+?)([ \t]*>[ \t]*)$' )
STRING_LITERAL_PATTERN = re.compile( r'"([^"\\]*(?:\\.[^"\\]*)*)"' )

# extensions that OpenSCAD can reference as an external file (import(), use<> for fonts, surface())
# rather than as source code to be pasted in
ASSET_EXTENSIONS = {
    ".stl", ".off", ".obj", ".amf", ".3mf", ".dxf", ".svg", ".png", ".ttf", ".otf", ".dat" }

MULTI_COLOR_MODE = "print-3mf"

########################################################################################################################


def Fail( message ):
    sys.stdout.flush()
    print( "error: " + message, file = sys.stderr )
    sys.exit( 1 )

########################################################################################################################


def TargetPath( base_dir, raw_path ):
    """The absolute path raw_path refers to, computed purely lexically (it need not exist)."""
    return ( base_dir / raw_path ).resolve()

########################################################################################################################


def IsInsideRepo( path ):
    try:
        path.relative_to( REPO_ROOT )
        return True
    except ValueError:
        return False

########################################################################################################################


def RelativePathForCombined( target_path ):
    return os.path.relpath( target_path, COMBINED_DIR ).replace( os.sep, "/" )

########################################################################################################################


def RewriteAssetLiteralsInLine( line, base_dir ):
    """Rewrites quoted file paths (import(), surface(), ...) so they still resolve once this file's
    content moves into combined/ - whether the file lives inside this repo (e.g. assets/) or, like a
    3rd-party part, outside it. Only touched when the path actually exists on disk, so plain text that
    happens to end in a recognised extension is left alone."""

    def Replace( match ):
        literal = match.group( 1 )
        if Path( literal ).suffix.lower() not in ASSET_EXTENSIONS:
            return match.group( 0 )
        target = TargetPath( base_dir, literal )
        if not target.is_file():
            return match.group( 0 )
        return '"%s"' % RelativePathForCombined( target )

    return STRING_LITERAL_PATTERN.sub( Replace, line )

########################################################################################################################


def CombineFile( path, included_scad_files ):
    """Returns the text of `path` with every in-repo include/use of a .scad file replaced (recursively)
    by that file's own combined text, in place, exactly where the directive was written."""

    base_dir = path.parent
    out_lines = []

    for line in path.read_text().splitlines():
        match = DIRECTIVE_PATTERN.match( line )
        if not match:
            out_lines.append( RewriteAssetLiteralsInLine( line, base_dir ) )
            continue

        indent, keyword, _, raw_target, _ = match.groups()
        target = TargetPath( base_dir, raw_target )
        resolved = target if IsInsideRepo( target ) and target.is_file() else None

        if resolved is None and not IsInsideRepo( target ):
            # points outside the repo entirely (e.g. a 3rd-party library checked out next to this repo).
            # Never copy that code in - but this file is moving into combined/, so fix the path so the
            # reference still resolves from its new home, even if the target doesn't exist on this machine.
            out_lines.append( "%s%s <%s>" % ( indent, keyword, RelativePathForCombined( target ) ) )
        elif resolved is None:
            # looks like an OPENSCADPATH library reference (e.g. MCAD/...), not a path relative to this
            # file - there's nothing in the repo to resolve it against, so leave it completely untouched
            out_lines.append( line )
        elif resolved.suffix.lower() != ".scad":
            # an in-repo asset (e.g. a font) referenced with use<> - keep it external, fix the path
            out_lines.append( "%s%s <%s>" % ( indent, keyword, RelativePathForCombined( resolved ) ) )
        elif resolved in included_scad_files:
            out_lines.append( "%s// (already inlined above from %s)" % ( indent, resolved.relative_to( REPO_ROOT ) ) )
        else:
            included_scad_files.add( resolved )
            banner = "/" * 120
            out_lines.append( "%s%s" % ( indent, banner ) )
            out_lines.append( "%s// inlined from %s" % ( indent, resolved.relative_to( REPO_ROOT ) ) )
            out_lines.append( "%s%s" % ( indent, banner ) )
            out_lines.append( CombineFile( resolved, included_scad_files ) )
            out_lines.append( "%s%s" % ( indent, banner ) )
            out_lines.append( "%s// end %s" % ( indent, resolved.relative_to( REPO_ROOT ) ) )
            out_lines.append( "%s%s" % ( indent, banner ) )

    return "\n".join( out_lines )

########################################################################################################################


def WriteCombinedFile( model_path ):
    COMBINED_DIR.mkdir( exist_ok = True )

    header = (
        "// combined, single-file build of %s\n"
        "// generated by generate-combined-scad.py - do not edit directly, regenerate it instead\n"
        "\n" % model_path.relative_to( REPO_ROOT ) )

    body = CombineFile( model_path, included_scad_files = set() )
    combined_path = COMBINED_DIR / ( model_path.stem + ".scad" )
    combined_path.write_text( header + body + "\n" )
    return combined_path

########################################################################################################################


def FindOpenscad():
    openscad = shutil.which( "openscad-nightly" ) or shutil.which( "openscad" )
    if not openscad:
        Fail( "could not find openscad-nightly or openscad on the PATH" )
    return openscad

########################################################################################################################


def FindPrintModes( combined_path ):
    modes = []
    for mode in RENDER_MODE_PATTERN.findall( combined_path.read_text() ):
        if mode not in modes:
            modes.append( mode )

    print_modes = [ mode for mode in modes if mode == "print" or mode.startswith( "print-" ) ]
    if not print_modes:
        Fail( "%s has no print modes (found: %s)" % ( combined_path, ", ".join( modes ) or "none" ) )
    return print_modes

########################################################################################################################


def IsMultiColorMode( mode ):
    return mode == MULTI_COLOR_MODE or mode.startswith( MULTI_COLOR_MODE + "-" )

########################################################################################################################


def OutputPath( combined_path, mode ):
    model_name = combined_path.stem
    if IsMultiColorMode( mode ):
        suffix = mode[ len( MULTI_COLOR_MODE ): ]
        return combined_path.with_name( "%s%s.3mf" % ( model_name, suffix ) )
    suffix = "" if mode == "print" else "-" + mode[ len( "print-" ): ]
    return combined_path.with_name( "%s%s.stl" % ( model_name, suffix ) )

########################################################################################################################


def Render( openscad, combined_path, mode, output_path ):
    command = [ openscad, "--enable=textmetrics" ]
    if IsMultiColorMode( mode ):
        command.append( "--enable=lazy-union" )
    command += [
        "-D", 'render_mode="%s"' % mode,
        "-o", str( output_path ),
        str( combined_path ) ]

    result = subprocess.run( command, capture_output = True, text = True )
    messages = [ line for line in result.stderr.splitlines() if line.startswith( ( "WARNING", "ERROR" ) ) ]
    succeeded = result.returncode == 0 and output_path.is_file() and output_path.stat().st_size > 0
    return succeeded, messages, result.stderr

########################################################################################################################


def main():
    parser = argparse.ArgumentParser(
        description = "Combine an OpenSCAD model and all its in-repo module dependencies into a single "
            "shareable .scad file, and render its print modes to STL/3MF, all under combined/." )
    parser.add_argument( "model", help = "path to the .scad file, e.g. gridfinity/gridfinity-ruler-bin.scad" )
    parser.add_argument( "--no-render", action = "store_true", help = "only write the combined .scad file" )
    args = parser.parse_args()

    model_path = Path( args.model )
    if not model_path.is_file():
        Fail( "file not found: %s" % model_path )
    if model_path.suffix != ".scad":
        Fail( "not an OpenSCAD file: %s" % model_path )
    model_path = model_path.resolve()

    combined_path = WriteCombinedFile( model_path )
    print( "wrote %s" % combined_path.relative_to( REPO_ROOT ) )

    if args.no_render:
        return

    print_modes = FindPrintModes( combined_path )
    openscad = FindOpenscad()

    print( "rendering %d print mode(s)" % len( print_modes ) )
    failed = False
    for mode in print_modes:
        output_path = OutputPath( combined_path, mode )
        succeeded, messages, stderr = Render( openscad, combined_path, mode, output_path )
        print( "  %-32s %s" % ( mode, "ok -> %s" % output_path.name if succeeded else "FAILED" ) )
        for message in messages:
            print( "      " + message )
        if not succeeded:
            failed = True
            if not messages:
                print( stderr )

    if failed:
        Fail( "one or more renders failed" )

########################################################################################################################


if __name__ == "__main__":
    main()
