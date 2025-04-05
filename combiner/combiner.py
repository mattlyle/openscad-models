#!/usr/bin/env python3

import re
import argparse
import os
import sys

####################################################################################################


def read_file(filename):

    lines = []
    symbols = {}

    with open(filename) as f:
        lines = f.readlines()

        i = 0
        while i < len(lines):

            # print("%3d [%s]" % (i, lines[i]))

            # remove comments
            comment_start = lines[i].find("#")
            if comment_start != -1:
                lines[i] = lines[i][:comment_start].strip()
                lines[i] = lines[i].rstrip()

            # Skip empty lines
            if len(lines[i]) == 0:
                del lines[i]
                continue

            # include
            match = re.match("^\\s*include\\s*<([-a-zA-Z0-9_./]+)>", lines[i])
            if match:
                include_filename = match.group(1)
                print("including: %s" % include_filename)
                include_lines, include_symbols = read_file(include_filename)

                del lines[i]
                i = i - 1

                for include_i in range(len(include_lines)):
                    lines.insert(include_i, include_lines[include_i])
                    i += len(include_lines)

            # use
            match = re.match("^\\s*use\\s*<([-a-zA-Z0-9_./]+)>", lines[i])
            if match:
                include_filename = match.group(1)
                print("using: %s" % include_filename)

            # next line...
            i = i + 1

    return lines, symbols


####################################################################################################


def main():
    parser = argparse.ArgumentParser(description="Process OpenSCAD files.")
    parser.add_argument("filename", help="The OpenSCAD file to process")
    args = parser.parse_args()

    # Get absolute path of the input file
    abs_path = os.path.abspath(args.filename)
    # Get the directory containing the file
    file_dir = os.path.dirname(abs_path)
    # Get just the filename
    base_filename = os.path.basename(abs_path)

    # Change to the directory of the input file
    orig_dir = os.getcwd()
    if file_dir:
        print(f"Changing directory to: {file_dir}")
        os.chdir(file_dir)

    try:
        lines, symbols = read_file(base_filename)

        for i in range(len(lines)):
            print("%3d | %s" % (i, lines[i]))
    finally:
        # Change back to the original directory
        if file_dir:
            os.chdir(orig_dir)


####################################################################################################


if __name__ == "__main__":
    main()

####################################################################################################
