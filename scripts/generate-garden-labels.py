#!/usr/bin/env python3
"""
generate-garden-labels.py

Renders a garden plant tag for every entry in LABELS from ../garden-plant-tags.scad, into a
new folder garden-plant-tag-v<N> in the output directory:

    garden-plant-tag-<plant>-<variety>-<orientation>-v<N>-c0.stl    the tag body
    garden-plant-tag-<plant>-<variety>-<orientation>-v<N>-c1.stl    the text
    garden-plant-tag-<plant>-<variety>-<orientation>-v<N>.3mf       both, as a multi-color 3MF

N is one more than the last garden-plant-tag version, shared by every tag in the run. It comes from
the same version file as build-openscad.py (.build-versions.json in the output directory), so see
that script for how the numbering works. Existing files and folders are never overwritten.

Like build-openscad.py, a real run stops while the model, the files it includes, or this script have
uncommitted changes (--allow-uncommitted overrides), and when nothing has changed since the last run
(--force overrides). A dry run skips the uncommitted check.

Pass --dry-run to render everything (so failures still surface) without writing anything.

The output directory and OpenSCAD binary come from the same config file as
build-openscad.py (~/.config/build-openscad/config.env, OUTPUT_DIR= and optional
OPENSCAD=), and BUILD_OPENSCAD_OUTPUT_DIR overrides OUTPUT_DIR.
"""

import argparse
import contextlib
import importlib.util
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

####################################################################################

SCAD_PATH = Path(__file__).resolve().parent.parent / "garden-plant-tags.scad"
CONFIG_PATH = Path.home() / ".config" / "build-openscad" / "config.env"

GENERATE_VERTICAL_TAGS = False

# [ first line, second line, first line offset y, second line offset y ]
LABELS = [
    ["Fresh Salsa", "Roma Tomato", -1, 1],
    ["SuperSauce", "Roma Tomato", -1, 0],
    ["Two Tasty", "Cherry Tomato", -1, 1],
    ["Veranda Red", "Cherry Tomato", -1, 1],
    ["Sungold", "Cherry Tomato", -1, 0],
    ["Bodacious", "Slicing Tomato", -1, 0],
    ["Tiger Eye", "Sunflower", -1, 1],
    ["Alaska", "Nasturtium", -1, 1],
    ["Asclepias", "Butterfly Weed", -1, 0],
    ["Queen Sophia", "Marigold", -1, 0],
    ["French Filet", "Bush Bean", -1, 0],
    ["Genovese", "Basil", -1, 0],
    ["Organic", "Oregano", -1, 0],
]

FILENAME_PREFIX = "garden-plant-tag-"

# the name the version file and the build folders use for these, like a model's name
MODEL_NAME = FILENAME_PREFIX.rstrip("-")

################################################################################


def fail(message):
    sys.stdout.flush()
    print("error: " + message, file=sys.stderr)
    sys.exit(1)


################################################################################


def read_config():
    config = {}
    if CONFIG_PATH.is_file():
        for line in CONFIG_PATH.read_text().splitlines():
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, value = line.split("=", 1)
            config[key.strip()] = value.strip().strip('"').strip("'")
    return config


################################################################################


def find_output_dir(config):
    output_dir = os.environ.get("BUILD_OPENSCAD_OUTPUT_DIR") or config.get("OUTPUT_DIR")
    if not output_dir:
        fail("no output directory configured - set OUTPUT_DIR in %s" % CONFIG_PATH)

    output_dir = Path(output_dir).expanduser()
    if not output_dir.is_dir():
        fail("output directory does not exist (is the NAS mounted?): %s" % output_dir)
    return output_dir


################################################################################


def find_openscad(config):
    openscad = config.get("OPENSCAD") or shutil.which("openscad-nightly") or shutil.which("openscad")
    if not openscad:
        fail("could not find openscad-nightly or openscad on the PATH (or set OPENSCAD in %s)" % CONFIG_PATH)
    return openscad


################################################################################


def load_build_script():
    """build-openscad.py, which does the version numbering for every build."""
    spec = importlib.util.spec_from_file_location("build_openscad", SCAD_PATH.parent / "build-openscad.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


################################################################################


def run_openscad(openscad, output_path, render_mode, label):
    first_line, second_line, first_line_offset_y, second_line_offset_y = label

    args = [openscad]
    if render_mode.startswith("print-3mf"):
        # keep the body and text as separate objects in the 3MF (see build-openscad.py)
        args.append("--enable=lazy-union")
    args += [
        "-D",
        'render_mode="%s"' % render_mode,
        "-D",
        'label_first_line="%s"' % first_line,
        "-D",
        'label_second_line="%s"' % second_line,
        "-D",
        "label_first_line_offset_y=%d" % first_line_offset_y,
        "-D",
        "label_second_line_offset_y=%d" % second_line_offset_y,
        "-o",
        str(output_path),
        str(SCAD_PATH),
    ]

    result = subprocess.run(args, capture_output=True, text=True)
    succeeded = result.returncode == 0 and output_path.is_file() and output_path.stat().st_size > 0

    print("  %-28s %-24s %s" % ("%s %s" % (second_line, first_line), render_mode, "ok" if succeeded else "FAILED"))
    for line in result.stderr.splitlines():
        if line.startswith(("WARNING", "ERROR")):
            print("      " + line)

    if not succeeded:
        fail("render failed - nothing was written")


################################################################################


def main():
    parser = argparse.ArgumentParser(description="Render a garden plant tag for every entry in LABELS.")
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="render everything to verify it works, but don't write anything to the output directory",
    )
    parser.add_argument("--force", action="store_true", help="run even if nothing has changed since the last run")
    parser.add_argument(
        "--allow-uncommitted",
        action="store_true",
        help="run even if the model, a file it includes, or this script has uncommitted changes",
    )
    args = parser.parse_args()

    config = read_config()
    output_dir = find_output_dir(config)
    openscad = find_openscad(config)
    build = load_build_script()

    # a dry run only reads the version file, so it doesn't take the lock
    lock = contextlib.nullcontext() if args.dry_run else build.BuildLock(output_dir)
    with lock:
        render_tags(args, build, output_dir, openscad)


################################################################################


def render_tags(args, build, output_dir, openscad):
    versions = build.ReadVersions(output_dir)

    # the labels in this script and the orientation are inputs too, so editing them counts as a change
    files = build.FindInputFiles(SCAD_PATH)
    inputs = build.HashInputs(files, openscad, extra=repr(LABELS) + str(GENERATE_VERTICAL_TAGS))
    checked_files = list(files) + [Path(__file__).resolve()]
    build.CheckBuildIsWanted(
        args.dry_run, args.force, args.allow_uncommitted, MODEL_NAME, output_dir, versions, checked_files, inputs
    )

    version = build.NextVersion(MODEL_NAME, output_dir, versions)
    build_dir = output_dir / build.BuildFolderName(MODEL_NAME, version)
    orientation = "vertical" if GENERATE_VERTICAL_TAGS else "horizontal"
    orientation_tag = "vert" if GENERATE_VERTICAL_TAGS else "horiz"

    if build_dir.exists():
        fail(
            "%s already exists, so the version file is out of step with the folders.\n"
            "Fix the garden-plant-tag entry in %s, or delete it to count from the folders again"
            % (build_dir, output_dir / build.VERSIONS_FILE_NAME)
        )

    dry_run_prefix = "[dry-run] " if args.dry_run else ""
    print(
        "%sgarden plant tags v%d: rendering %d %s tags into %s"
        % (dry_run_prefix, version, len(LABELS), orientation, build_dir)
    )

    # render everything to a temporary directory first, so a failure never leaves a partial version behind
    with tempfile.TemporaryDirectory(prefix="garden-labels-") as temp_dir:
        rendered = []
        for label in LABELS:
            first_line, second_line = label[0], label[1]
            base_name = "%s%s-%s-%s-v%d" % (
                FILENAME_PREFIX,
                second_line.lower().replace(" ", "-"),
                first_line.lower().replace(" ", "-"),
                orientation_tag,
                version,
            )

            for render_mode, file_name in [
                ("print-body-%s" % orientation, base_name + "-c0.stl"),
                ("print-text-%s" % orientation, base_name + "-c1.stl"),
                ("print-3mf-%s" % orientation, base_name + ".3mf"),
            ]:
                temp_path = Path(temp_dir) / file_name
                run_openscad(openscad, temp_path, render_mode, label)
                rendered.append((temp_path, build_dir / file_name))

        if not args.dry_run:
            build_dir.mkdir()
            try:
                for temp_path, target in rendered:
                    with open(temp_path, "rb") as source, open(target, "xb") as destination:
                        shutil.copyfileobj(source, destination)

                # the version is only recorded once everything is written, so a failed run never uses up a number
                versions[MODEL_NAME] = build.BuildRecord(version, inputs, build.CurrentCommit(SCAD_PATH))
                build.WriteVersions(output_dir, versions)
            except BaseException:
                # the folder was just made by this run, so a half-written version is removed with it
                shutil.rmtree(build_dir)
                raise

    print()
    verb = "would write" if args.dry_run else "wrote"
    print("%s%s %d files in %s" % (dry_run_prefix, verb, len(rendered), build_dir))
    print()
    print("%sversion: garden plant tags v%d" % (dry_run_prefix, version))


################################################################################

if __name__ == "__main__":
    main()

################################################################################
