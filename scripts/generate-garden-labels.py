#!/usr/bin/env python3

import subprocess

####################################################################################

# OUT_PATH = "~/projects/openscad-models/_renders"
OUT_PATH = "~/projects/openscad-models/_temp"
SCAD_PATH = "~/projects/openscad-models/garden-plant-tags.scad"

VERSION = 5

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


def main():

    for label in LABELS:
        first_line = label[0]
        second_line = label[1]

        body_filename = "garden-plant-tag-%s-%s-v%d-c0.stl" % (
            second_line.lower().replace(" ", "-"),
            first_line.lower().replace(" ", "-"),
            VERSION,
        )

        print("%-60s | %-16s | %s" % (body_filename, first_line, second_line))

        # generate body STL
        subprocess.run(
            [
                "openscad-nightly",
                "scripts/generate-label.py",
                "-o",
                body_filename,
                "-D",
                "render_mode=print-body",
                "-D",
                "label_first_line=" % (first_line),
                "-D",
                "label_second_line=" % (second_line),
            ]
        )

        break  # TODO: REMOVE

    return


################################################################################

if __name__ == "__main__":
    main()

################################################################################
