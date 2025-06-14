"""
Keybindings for the laptop (fedora-laptop) environment.

This module includes laptop-specific key bindings plus global ones.
"""

from libqtile.config import Key
from libqtile.lazy import lazy

from global_keys import global_keys, global_mouse, mod

# Laptop-specific key bindings
laptop_keys = [
    # Laptop-specific app launchers
    Key([mod], "Return", lazy.spawn("kitty"), desc="Launch terminal"),
    Key([mod], "z", lazy.spawn("pcmanfm"), desc="Launch file manager"),
    # Laptop-specific window switching with Control+Tab
    Key(
        [mod, "control"],
        "Tab",
        lazy.layout.next(),
        desc="Move window focus to other window",
    ),
    # Laptop-specific media controls (different key bindings)
    Key([], "Cancel", lazy.spawn("playerctl play-pause"), desc="Play/Pause media"),
    Key([], "XF86Favorites", lazy.spawn("playerctl next"), desc="Next track"),
    Key([], "XF86Messenger", lazy.spawn("playerctl previous"), desc="Previous track"),
    # Brightness controls (laptop only)
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("brightnessctl set +500"),
        desc="Increase brightness",
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("brightnessctl set 500-"),
        desc="Decrease brightness",
    ),
]

# Combine global and laptop-specific keys
keys = global_keys + laptop_keys

# Use the global mouse bindings
mouse = global_mouse
