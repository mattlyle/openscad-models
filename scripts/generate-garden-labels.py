#!/usr/bin/env python3

import os
import subprocess

####################################################################################

OUT_PATH = "../_renders"
SCAD_PATH = "../garden-plant-tags.scad"

VERSION = 10

GENERATE_VERITCAL_TAGS = False

LABELS = [
    ["Fresh Salsa", "Roma Tomato"],
    ["SuperSauce", "Roma Tomato"],
    ["Two Tasty", "Cherry Tomato"],
    ["Veranda Red", "Cherry Tomato"],
    ["Sungold", "Cherry Tomato"],
    ["Bodacious", "Slicing Tomato"],
    ["Tiger Eye", "Sunflower"],
    ["Alaska", "Nasturtium"],
    ["Asclepias", "Butterfly Weed"],
]

################################################################################


def run_openscad(output_filename, render_mode, first_line, second_line):

    print("Generating %s" % (output_filename))
    result = subprocess.run(
        [
            "openscad-nightly",
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
            SCAD_PATH,
        ],
        capture_output=True,
        text=True,
    )
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
        )

    return


################################################################################

if __name__ == "__main__":
    main()

################################################################################
