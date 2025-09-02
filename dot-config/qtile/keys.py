"""
Keybindings for the desktop (fedora) environment.

This module includes desktop-specific key bindings plus global ones.
"""

import os

from libqtile.config import Key
from libqtile.lazy import lazy

from global_keys import global_keys, global_mouse, mod

# Desktop-specific key bindings
desktop_keys = [
    # Desktop-specific app launchers
    Key(
        [mod],
        "p",
        lazy.spawn(os.path.expanduser("~/Documents/appimages/FreeTube.AppImage")),
        desc="Launch FreeTube",
    ),
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
]

# Combine global and desktop-specific keys
keys = global_keys + desktop_keys

# Use the global mouse bindings
mouse = global_mouse
