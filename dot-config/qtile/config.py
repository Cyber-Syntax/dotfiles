# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
import os
import re  # this fixes the Match error on group
import subprocess

from libqtile import hook, layout
from libqtile.config import DropDown, Group, Key, Match, ScratchPad
from libqtile.lazy import lazy

from functions import *
from global_keys import mod  # Import mod from global_keys
from variables import *

"""
Log location
~/.local/share/qtile/qtile.log
`qtile cmd-obj -o cmd -f get_screens ` # find the screen index
@param: screen_affinity: monitor to display the group on
DP-2   left monitor    :   screen_affinity=0, group 2 # primary asus
DP_4   right monitor :   screen_affinity=1, group 4 # view right
"""


# 2 machine setup
def get_hostname():
    hostname = subprocess.check_output(["hostname"]).decode("utf-8").strip()
    return hostname


hostname = get_hostname()

if hostname == "fedora":
    from keys import keys
    from widget import *
elif hostname == "fedora-laptop":
    from laptopKeys import keys
    from laptopWidget import *
else:
    print("No hostname found")
    # Fallback to global keys if hostname not recognized
    from global_keys import global_keys as keys
    from global_keys import mod

groups = [
    Group(
        "1",
        screen_affinity=0,
        layout="max",
        matches=[
            Match(
                wm_class=re.compile(
                    r"^(firefox|brave-browser|chromium-browser|librewolf)$"
                )
            )
        ],
        label=" ",
    ),
    Group(
        "2",
        screen_affinity=0,
        layout="max",
        matches=[Match(wm_class=re.compile(r"^(code|zed)$"))],
        label="",
    ),
    Group(
        "3",
        screen_affinity=0,
        layout="max",
        matches=[Match(wm_class=re.compile(r"^(siyuan|obsidian|freetube)$"))],
        label=" ",
    ),
    Group(
        "4",
        screen_affinity=0,
        layout="max",
        matches=[Match(wm_class=re.compile(r"^superproductivity$"))],
        label=" ",
    ),
    Group(
        "5",
        screen_affinity=0,
        layout="max",
        matches=[Match(wm_class=re.compile(r"^(spotify|Spotify)$"))],
        label=" ",
    ),
    Group(
        "6",
        screen_affinity=0,
        layout="monadtall",
        matches=[Match(wm_class=re.compile(r"^(pcmanfm)$"))],
        label=" ",
    ),
]
for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key([mod], i.name, lazy.group[i.name].toscreen()),
            # switch to group with ability to go to prevous group if pressed again
            # Key([mod], i.name, lazy.function(toscreen, i.name)),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
        ]
    )
# TODO: use variables module
# add all of the variables withou wildcard imports
terminal_hold = "kitty -d --hold"  # Default terminal
# Scratchpad
groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "khal",
                terminal_hold + "khal calendar",
                x=0.6785,
                width=0.32,
                height=0.997,
                opacity=1,
            ),
            # define a drop down terminal.
            # it is placed in the upper third of screen by default.
            DropDown(  # F10
                "term",
                # HACK:
                "kitty -d ~",
                opacity=0.8,
                width=0.5,
                height=0.5,
                x=0.3,
                y=0.3,
                # on_focus_lost_hide=False,  # Keep open until manually hidden
            ),
            # DropDown(  # F11
            #     "social",
            #     "/home/developer/Documents/appimages/FreeTube.AppImage",
            #     opacity=0.8,
            #     width=0.5,
            #     height=0.5,
            #     x=0.3,
            #     y=0.3,
            #     # on_focus_lost_hide=False,  # Keep open until manually hidden
            # ),
            DropDown(  # F12
                "chat",
                "signal-desktop",
                opacity=0.8,
                width=0.5,
                height=0.5,
                x=0.3,
                y=0.3,
                # on_focus_lost_hide=False,  # Keep open until manually hidden
            ),
        ],
    ),
)

layout_theme = {
    "border_width": layouts_border_width,
    "margin": layouts_margin,
    "border_focus": layouts_border_focus_color,
    "border_normal": layouts_border_color,
    "border_on_single": layouts_border_on_single,
}


layouts = [
    # layout.TreeTab(),
    layout.MonadTall(**layout_theme),
    layout.Max(
        border_width=0,
        margin=0,
    ),
]

floating_layout = layout.Floating(
    **layout_theme,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="Seahorse"),  # gitk
        Match(wm_class="keepassxc"),  # gitk
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry,
        *[Match(wm_class=app) for app in floating_apps],
    ],
)

auto_fullscreen = True
focus_on_window_activation = "focus"  # urgent, smart, focus, or None
reconfigure_screens = True
bring_front_click = False
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
bring_front_click = False
cursor_warp = True
follow_mouse_focus = True
auto_minimize = True  # steam etc.

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~/.config/qtile/scripts/autostart.sh")
    subprocess.Popen([home])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
# """
# """
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
