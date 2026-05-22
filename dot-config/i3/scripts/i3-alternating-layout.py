#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11,<3.14"
# dependencies = [
# "i3ipc"
# ]
# ///

# Author: https://github.com/olemartinorg/i3-alternating-layout
# Maintainer for current: Cyber-Syntax


import getopt
import logging
import os
import sys
from pathlib import Path

from i3ipc import Connection, Event

log_path = Path("~/.config/i3/logs/i3-alternating-layout.log").expanduser()
log_path.parent.mkdir(parents=True, exist_ok=True)  # Create dirs if needed

# Set up logging
logging.basicConfig(
    level=logging.ERROR,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler(log_path),
        logging.StreamHandler(),
    ],
)


def find_parent(i3, window_id):
    """Find the parent of a given window id."""
    try:

        def finder(con, parent):
            if con.id == window_id:
                return parent
            for node in con.nodes:
                res = finder(node, con)
                if res:
                    return res
            return None

        return finder(i3.get_tree(), None)
    except Exception as e:
        logging.error(f"Error in find_parent: {e}", exc_info=True)
        return None


def set_layout(i3, e):
    """Set the layout/split.

    for the currently focused window to either vertical or
    horizontal, depending on its width/height
    """
    try:
        win = i3.get_tree().find_focused()
        if not win:
            logging.debug("No focused window found")
            return

        parent = find_parent(i3, win.id)

        if not parent:
            logging.debug("No parent found for window")
            return

        if parent and parent.layout != "tabbed" and parent.layout != "stacked":
            if win.rect.height > win.rect.width:
                if parent.orientation == "horizontal":
                    i3.command("split v")
            else:
                if parent.orientation == "vertical":
                    i3.command("split h")
    except Exception as e:
        logging.error(f"Error in set_layout: {e}", exc_info=True)


def print_help():
    print("Usage: " + sys.argv[0] + " [-p path/to/pid.file]")
    print("")
    print("Options:")
    print(
        "    -p path/to/pid.file   Saves the PID for this program in the filename specified"
    )
    print("")


def main():
    """
    Main function - listen for window focus
        changes and call set_layout when focus
        changes
    """
    try:
        opt_list, _ = getopt.getopt(sys.argv[1:], "hp:")
        pid_file = None
        for opt in opt_list:
            if opt[0] == "-h":
                print_help()
                sys.exit()
            if opt[0] == "-p":
                pid_file = opt[1]

        if pid_file:
            Path(pid_file).write_text(str(os.getpid()))

        logging.info("work as expected")
        i3 = Connection()
        i3.on(Event.WINDOW_FOCUS, set_layout)
        i3.main()
    except KeyboardInterrupt:
        logging.info("Received keyboard interrupt, exiting gracefully")
        sys.exit(0)
    except Exception as e:
        logging.error(f"Fatal error in main: {e}", exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
