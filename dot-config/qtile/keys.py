"""
Keybindings for the desktop (fedora) environment.

This module includes desktop-specific key bindings plus global ones.
"""

from libqtile.config import Key
from libqtile.lazy import lazy

from functions import (
    cycle_groups,
    cycle_groups_reverse,
    focus_left_mon,
    focus_right_mon,
    send_left,
    send_right,
)
from global_keys import global_keys, global_mouse, mod

# Desktop-specific key bindings
desktop_keys = [
    # Scratchpad keys
    Key(
        [mod],
        "F10",
        lazy.group["scratchpad"].dropdown_toggle("term"),
        desc="Toggle terminal scratchpad",
    ),
    Key(
        [mod],
        "F12",
        lazy.group["scratchpad"].dropdown_toggle("chat"),
        desc="Toggle chat scratchpad",
    ),
    # Screen/Group management
    Key([mod], "Tab", cycle_groups, desc="Move to next group"),
    Key(
        [mod, "shift"],
        "Tab",
        cycle_groups_reverse,
        desc="Move to previous group",
    ),
    # Focus left monitor (dp-0)
    Key(
        [mod],
        "a",
        focus_left_mon,
        desc="Focus left monitor",
    ),
    # Focus right monitor (dp-4)
    Key(
        [mod],
        "d",
        focus_right_mon,
        desc="Focus right monitor",
    ),
    # Send window to left monitor (dp-0)
    Key(
        [mod, "shift"],
        "a",
        send_left,
        desc="Send window to left monitor",
    ),
    # Send window to right monitor (dp-4)
    Key(
        [mod, "shift"],
        "d",
        send_right,
        desc="Send window to right monitor",
    ),
]

# Combine global and desktop-specific keys
keys = global_keys + desktop_keys

# Use the global mouse bindings
mouse = global_mouse
