#!/usr/bin/env python3

import os
import subprocess

####################################################################################

OPENSCAD_PATH = "/home/matt/apps/OpenSCAD-2025.05.04.ai25246-x86_64.AppImage"

OUT_PATH = "/media/turbo-nas/3d-printing/_renders"
SCAD_PATH = "../garden-plant-tags.scad"

VERSION = 11

GENERATE_VERITCAL_TAGS = False

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
]

################################################################################


def run_openscad(
    output_filename,
    render_mode,
    first_line,
    second_line,
    first_line_offset_y,
    second_line_offset_y,
):

    args = [
        OPENSCAD_PATH,
        "-o",
        output_filename,
        "--enable",
        "textmetrics",
        "--backend",
        "manifold",
        "-D",
        'render_mode="%s"' % (render_mode),
        "-D",
        'label_first_line="%s"' % (first_line),
        "-D",
        'label_second_line="%s"' % (second_line),
        "-D",
        "label_first_line_offset_y=%d" % first_line_offset_y,
        "-D",
        "label_second_line_offset_y=%d" % second_line_offset_y,
        SCAD_PATH,
    ]

    # print("command:", " ".join(args))

    print("First line:      %s" % first_line)
    print("Second line:     %s" % second_line)
    print("Render mode:     %s" % render_mode)
    print("Output filename: %s" % (output_filename))
    result = subprocess.run(args, capture_output=True, text=True)

    print("Return code:", result.returncode)
    print("stdout:")
    if result.stdout:
        print("    " + result.stdout.replace("\n", "\n    "))
    print("stderr:")
    if result.stderr:
        print("    " + result.stderr.replace("\n", "\n    "))

    if result.returncode != 0:
        raise Exception("Failure generating STL")

    if "NoError" in result.stdout:
        raise Exception("Likely an error in the geometry")

    print()

    return


################################################################################


def main():

    for label in LABELS:
        first_line = label[0]
        second_line = label[1]
        first_line_offset_y = label[2]
        second_line_offset_y = label[3]

        orientation = "vert" if GENERATE_VERITCAL_TAGS else "horiz"

        body_filename = "garden-plant-tag-%s-%s-%s-v%d-c0.stl" % (
            second_line.lower().replace(" ", "-"),
            first_line.lower().replace(" ", "-"),
            orientation,
            VERSION,
        )

        # print("%-60s | %-16s | %s" % (body_filename, first_line, second_line))

        # generate the body
        run_openscad(
            os.path.join(OUT_PATH, body_filename),
            "print-body-vertical" if GENERATE_VERITCAL_TAGS else "print-body-horizontal",
            first_line,
            second_line,
            first_line_offset_y,
            second_line_offset_y,
        )

        text_filename = "garden-plant-tag-%s-%s-%s-v%d-c1.stl" % (
            second_line.lower().replace(" ", "-"),
            first_line.lower().replace(" ", "-"),
            orientation,
            VERSION,
        )

        run_openscad(
            os.path.join(OUT_PATH, text_filename),
            "print-text-vertical" if GENERATE_VERITCAL_TAGS else "print-text-horizontal",
            first_line,
            second_line,
            first_line_offset_y,
            second_line_offset_y,
        )

    return


################################################################################

if __name__ == "__main__":
    main()

################################################################################
