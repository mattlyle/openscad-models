#!/usr/bin/env python3
"""
generate-garden-labels.py

Renders a garden plant tag for every entry in LABELS from ../garden-plant-tags.scad:

    garden-plant-tag-<plant>-<variety>-<orientation>-v<N>-c0.stl    the tag body
    garden-plant-tag-<plant>-<variety>-<orientation>-v<N>-c1.stl    the text
    garden-plant-tag-<plant>-<variety>-<orientation>-v<N>.3mf       both, as a multi-color 3MF

N is one more than the highest existing garden-plant-tag version in the output
directory, shared by every tag in the run. Existing files are never overwritten.

The output directory and OpenSCAD binary come from the same config file as
build-openscad.py (~/.config/build-openscad/config.env, OUTPUT_DIR= and optional
OPENSCAD=), and BUILD_OPENSCAD_OUTPUT_DIR overrides OUTPUT_DIR.
"""

import os
import re
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


def find_next_version(output_dir):
    pattern = re.compile(r"^%s.+-v(\d+)(?:-c\d+)?\.(?:stl|3mf)$" % re.escape(FILENAME_PREFIX))
    versions = [int(match.group(1)) for match in (pattern.match(path.name) for path in output_dir.iterdir()) if match]
    return max(versions, default=-1) + 1


################################################################################


def run_openscad(openscad, output_path, render_mode, label):
    first_line, second_line, first_line_offset_y, second_line_offset_y = label

    args = [openscad, "--enable=textmetrics"]
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
    config = read_config()
    output_dir = find_output_dir(config)
    openscad = find_openscad(config)

    version = find_next_version(output_dir)
    orientation = "vertical" if GENERATE_VERTICAL_TAGS else "horizontal"
    orientation_tag = "vert" if GENERATE_VERTICAL_TAGS else "horiz"

    print("garden plant tags v%d: rendering %d %s tags into %s" % (version, len(LABELS), orientation, output_dir))

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
                rendered.append((temp_path, output_dir / file_name))

        for _, target in rendered:
            if target.exists():
                fail("refusing to overwrite existing file: %s" % target)

        for temp_path, target in rendered:
            with open(temp_path, "rb") as source, open(target, "xb") as destination:
                shutil.copyfileobj(source, destination)

    print()
    print("wrote %d files" % len(rendered))
    print()
    print("version: garden plant tags v%d" % version)


################################################################################

if __name__ == "__main__":
    main()

################################################################################
