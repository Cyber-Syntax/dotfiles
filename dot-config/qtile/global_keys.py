"""
Global key bindings shared between all Qtile machines.

This module defines keybindings that are common to all machines,
reducing code duplication and making configuration more maintainable.
"""

import os

from libqtile.config import Click, Drag, Key, KeyChord
from libqtile.lazy import lazy

# Define constants
mod = "mod4"  # Sets mod key to SUPER/WINDOWS
# TERMINAL = "kitty -d ~"  # My terminal of choice
TERMINAL = "alacritty"  # My terminal of choice
# TERMINAL = "ghostty"
BROWSER = "brave"  # My browser of choice

# Common mouse bindings
global_mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click([mod], "Button1", lazy.window.bring_to_front()),
]

# Common key bindings for all machines
global_keys = [
    # Key chords
    # The below code will launch brave when the user presses Mod + less(<), followed by b.
    KeyChord([mod], "less", [Key([], "b", lazy.spawn("brave-browser"))]),
    # apps
    Key([mod], "Return", lazy.spawn(TERMINAL), desc="Launch terminal"),
    # Window management
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Qtile management
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    # Change location of the windows like left: 1,2,3 right:1
    # became left:1 , right: 1,2,3 window.
    Key([mod, "shift"], "space", lazy.layout.flip()),
    # Apps
    ## folder pcmanfm
    Key([mod], "z", lazy.spawn("pcmanfm"), desc="Launch file manager"),
    # Window focus and movement
    Key([mod], "w", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod], "e", lazy.layout.shuffle_up(), desc="Move window up"),
    Key(
        [mod], 49, lazy.layout.next(), desc="Move window focus to other window"
    ),
    # Applications
    # Key([mod], "less", lazy.spawn("firefox"), desc="Launch firefox"),
    Key([mod], "l", lazy.spawn("i3lock"), desc="Lock the screen"),
    # Rofi menus
    Key(
        [mod],
        "r",
        lazy.spawn(
            os.path.expanduser("~/.config/rofi/launchers/type-3/launcher.sh")
        ),
        desc="Launch application launcher",
    ),
    Key(
        [mod],
        "x",
        lazy.spawn(
            os.path.expanduser("~/.config/rofi/powermenu/type-6/powermenu.sh")
        ),
        desc="Launch power menu",
    ),
    Key(
        [mod],
        "m",
        lazy.spawn(
            "pactl set-default-sink $(pactl list short sinks |awk '{print $2}' | rofi -dmenu)"
        ),
        desc="Change audio output device",
    ),
    # printscreen for `flameshot gui` command
    Key([], "Print", lazy.spawn("flameshot gui")),
    # Media control
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
        desc="Toggle mute",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -10%"),
        desc="Lower volume",
    ),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +10%"),
        desc="Raise volume",
    ),
    # Generic media playback controls (hardware buttons vary by machine)
    # These will be overridden by machine-specific configs when needed
    Key(
        [],
        "XF86AudioPlay",
        lazy.spawn("playerctl play-pause"),
        desc="Play/Pause media",
    ),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc="Next track"),
    Key(
        [],
        "XF86AudioPrev",
        lazy.spawn("playerctl previous"),
        desc="Previous track",
    ),
]
