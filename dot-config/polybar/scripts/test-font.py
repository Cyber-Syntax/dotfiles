#!/usr/bin/env -S uv run --script
#
# /// script
# requires-python = ">=3.13"
# dependencies = [
#  "freetype-py",
# ]
# ///

import subprocess
import sys

from freetype import Face


def has_glyph(fontfile, char):
    try:
        face = Face(fontfile)
        # select a Unicode charmap if needed
        # many fonts already default; else use face.select_charmap(...)
        charcode = ord(char)
        glyph_index = face.get_char_index(charcode)
        return glyph_index != 0
    except Exception:
        # skip fonts that FreeType can't open
        return False


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <character>")
        sys.exit(1)
    char = sys.argv[1]
    # get font list from fc-list
    try:
        # Using ": " delimiter as in your Perl script
        proc = subprocess.run(
            ["fc-list"], check=True, stdout=subprocess.PIPE, text=True
        )
    except subprocess.CalledProcessError as e:
        print("Error running fc-list:", e, file=sys.stderr)
        sys.exit(1)
    for line in proc.stdout.splitlines():
        parts = line.split(": ", 1)
        if len(parts) != 2:
            continue
        fontfile, name = parts
        if has_glyph(fontfile, char):
            print(line)


if __name__ == "__main__":
    main()
