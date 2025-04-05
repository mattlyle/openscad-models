#!/usr/bin/env python3

import re
import argparse
import os

####################################################################################################


def read_file(filename):

    new_dir = os.path.dirname(filename)
    base_filename = os.path.basename(filename)

    new_dir_aws = os.path.abspath(new_dir)

    # print("=============================================")
    # print("filename:      %s" % filename)
    # print("current path:  %s" % os.getcwd())
    # print("new_dir:       %s (%s)" % (new_dir, new_dir_aws))
    # print("base_filename: %s" % base_filename)
    # print()

    # switch to the directory of the file
    os.chdir(new_dir_aws)

    lines = []
    symbols = {}

    with open(base_filename) as f:
        lines = f.readlines()

    # first pass: remove comments and empty lines
    i = 0
    while i < len(lines):

        # print("%3d [%s]" % (i, lines[i]))

        lines[i] = lines[i].rstrip()

        # remove comments
        comment_start = lines[i].find("//")
        if comment_start != -1:
            lines[i] = lines[i][:comment_start].rstrip()

        # remove block comments
        # TODO: finish

        # Skip empty lines
        if len(lines[i]) == 0:
            del lines[i]
            continue

        i = i + 1

    # second pass: process includes and use statements
    i = 0
    while i < len(lines):

        # print("at %d = %s" % (i, lines[i]))

        # include
        match = re.match("^\\s*include\\s*<([-a-zA-Z0-9_./]+)>", lines[i])
        if match:
            include_filename = match.group(1)
            print("including: %s" % include_filename)

            # remove this include line
            # lines[i] = "#>>> " + lines[i]
            del lines[i]
            i = i - 1

            include_lines, include_symbols = read_file(include_filename)

            # switch back to the original directory
            os.chdir(new_dir_aws)

            for include_i in range(len(include_lines)):
                lines.insert(include_i, include_lines[include_i])
            i += len(include_lines)

        # use
        match = re.match("^\\s*use\\s*<([-a-zA-Z0-9_./]+)>", lines[i])
        if match:
            use_filename = match.group(1)
            print("using: %s" % use_filename)
            raise NotImplementedError("use not implemented yet")

        # next line...
        i = i + 1

    return lines, symbols


####################################################################################################


def main():
    parser = argparse.ArgumentParser(description="Process OpenSCAD files with includes into a single combined file")
    parser.add_argument("input", help="The OpenSCAD file to process")
    parser.add_argument("output", help="The OpenSCAD file to write")
    args = parser.parse_args()

    with open(args.output, "w") as f:
        lines, symbols = read_file(args.input)
        for line in lines:
            f.write(line)
            f.write("\n")

    return


####################################################################################################


if __name__ == "__main__":
    main()

####################################################################################################
