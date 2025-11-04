import re
import os
import subprocess

import libqtile.resources
from libqtile import bar, layout, qtile, widget, hook
from qtile_extras import widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# custom modules
from functions import get_appimage_updates, get_fedora_updates, smart_parse_text

mod = "mod4"
terminal = guess_terminal()

# TESTING: making so simple qtile for better performance only for desktop for now
# and making sure that I wasn't make mistakes via my functions which log give error about
# `TypeError: a coroutine was expected, got None`

# Theme
# Nord theme usage:
# Call it in widget like:
# text_colour = nord["foreground"]
# error_colour = nord["error"]
nord = {
    "foreground": "#D8DEE9",
    "background": "#2E3440",
    "alt_background": "#3B4252",
    "disabled": "#4C566A",
    "accent": "#81A1C1",
    "warning": "#EBCB8B",  # nord yellow for warnings
    "error": "#BF616A",  # nord red for errors
}


keys = [
    # Screen/Group management
    # skip_empty: skip the empty workspaces/groups when cycling
    Key(
        [mod],
        "Tab",
        # lazy.screen.next_group(skip_empty=True),
        lazy.screen.next_group(),
        desc="Move to next group",
    ),
    Key(
        [mod, "shift"],
        "Tab",
        lazy.screen.prev_group(),
        desc="Move to previous group",
    ),
    # Window focus and movement
    Key([mod], "d", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "a", lazy.layout.up(), desc="Move focus up"),
    #
    # Key chords
    # The below code will launch brave when the user presses Mod + less(<), followed by b.
    KeyChord([mod], "less", [Key([], "b", lazy.spawn("brave-browser"))]),
    # apps
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
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
    Key([mod], 49, lazy.layout.next(), desc="Move window focus to other window"),
    # Applications
    # Key([mod], "less", lazy.spawn("firefox"), desc="Launch firefox"),
    Key([mod], "l", lazy.spawn("i3lock"), desc="Lock the screen"),
    # Rofi menus
    Key(
        [mod],
        "r",
        lazy.spawn(os.path.expanduser("~/.config/rofi/launchers/type-3/launcher.sh")),
        desc="Launch application launcher",
    ),
    Key(
        [mod],
        "x",
        lazy.spawn(os.path.expanduser("~/.config/rofi/powermenu/type-6/powermenu.sh")),
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

# # Add key bindings to switch VTs in Wayland.
# # We can't check qtile.core.name in default config as it is loaded before qtile is started
# # We therefore defer the check until the key binding is run by using .when(func=...)
# for vt in range(1, 8):
#     keys.append(
#         Key(
#             ["control", "mod1"],
#             f"f{vt}",
#             lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
#             desc=f"Switch to VT{vt}",
#         )
#     )
#

groups = [
    Group(
        "1",
        layout="max",
        matches=[
            Match(
                wm_class=re.compile(
                    r"^(firefox|brave-browser|chromium-browser|librewolf|zen)$"
                )
            )
        ],
        label=" ",
    ),
    Group(
        "2",
        layout="max",
        matches=[Match(wm_class=re.compile(r"^(code|zed)$"))],
        label="",
    ),
    Group(
        "3",
        layout="monadtall",
        matches=[Match(wm_class=re.compile(r"^(siyuan|obsidian|freetube|heroic)$"))],
        label=" ",
    ),
    Group(
        "4",
        layout="max",
        matches=[Match(wm_class=re.compile(r"^superproductivity$"))],
        label=" ",
    ),
    Group(
        "5",
        layout="max",
        matches=[Match(wm_class=re.compile(r"^(spotify|Spotify)$"))],
        label=" ",
    ),
    Group(
        "6",
        layout="monadtall",
        matches=[Match(wm_class=re.compile(r"^(pcmanfm|virt-manager)$"))],
        label=" ",
    ),
]


for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

### Widgets and Bars ###

widget_defaults = dict(
    font="JetbrainsMono Nerd Font",
    foreground=nord["foreground"],
    padding=15,
    fontsize=12,
)

extension_defaults = widget_defaults.copy()


space = widget.Spacer(length=5, decorations=[])

# logo = os.path.join(os.path.dirname(libqtile.resources.__file__), "logo.png")
screens = [
    Screen(
        top=bar.Bar(
            [
                # widget.GroupBox(),
                space,
                widget.TaskList(
                    border="#414868",
                    highlight_method="block",
                    max_title_width=80,
                    txt_minimized="",
                    txt_floating="",
                    txt_maximized="",
                    parse_text=smart_parse_text,
                    spacing=3,
                    icon_size=25,
                    border_width=0,
                    fontsize=13,
                    stretch=False,
                    padding_x=1,
                    padding_y=1,
                    hide_crash=True,
                    theme_path=[
                        "~/.local/share/icons/",
                        "~/.local/share/flatpak/exports/share/icons/",
                        "/var/lib/flatpak/exports/share/icons/",
                    ],
                ),
                space,
                widget.Spacer(),
                widget.PulseVolumeExtra(
                    fmt="{}",
                    theme_path="/home/developer/.config/qtile/icons/volume/",
                    icon_size=20,
                    limit_normal=80,
                    limit_high=100,
                    limit_loud=101,
                    mode="both",
                ),
                space,
                # Thermal sensor for CPU temperature
                widget.ThermalSensor(
                    tag_sensor="Tctl",
                    foreground=nord["foreground"],
                    fmt="🌡️ {}",
                    update_interval=2,
                    threshold=60,
                    foreground_alert="ff6000",
                    mouse_callbacks={
                        "Button1": lambda: qtile.spawn(terminal + " htop"),
                        "Button3": lambda: qtile.spawn(terminal + " btop"),
                    },
                ),
                space,
                # NVIDIA GPU sensor
                widget.NvidiaSensors(
                    fmt="⚡ {}",
                    format="{temp}°C {fan_speed} {perf}",
                    update_interval=2,
                    threshold=60,
                    foreground_alert="ff6000",
                    mouse_callbacks={
                        "Button1": lambda: qtile.spawn(
                            terminal + " watch -n 2 'nvidia-smi'"
                        )
                    },
                ),
                space,
                # FIXME: both give erorr: `TypeError: initializer for ctype 'PangoLayout *' must be a cdata pointer, not NoneType`
                # TODO: use GenPollCommand instead?
                # AppImage updates check
                widget.GenPollText(
                    name="my-unicorn",
                    func=get_appimage_updates,
                    update_interval=None,  # Check only once on startup
                    mouse_callbacks={
                        "Button1": lambda: qtile.spawn(
                            'alacritty -e bash -c "/home/developer/Documents/my-repos/my-unicorn/scripts/update.bash --update-outdated"'
                        ),
                    },
                ),
                space,
                # Fedora package manager updates check
                widget.GenPollText(
                    name="fedora-package-manager",
                    func=get_fedora_updates,
                    update_interval=None,  # Check only once on startup
                    mouse_callbacks={
                        "Button1": lambda: qtile.spawn(
                            'alacritty -e bash -c "/home/developer/.local/share/linux-system-utils/package-management/fedora-package-manager.sh --update"'
                        ),
                    },
                ),
                space,
                # Media player status (MPRIS2)
                widget.Mpris2(
                    fmt="{}",
                    format=" {xesam:title} - {xesam:artist}",
                    paused_text="  {track}",
                    playing_text="  {track}",
                    scroll_fixed_width=False,
                    max_chars=200,
                    separator=", ",
                    stopped_text="",
                    width=200,
                ),
                space,
                # Disk usage for root partition
                widget.DF(
                    update_interval=600,
                    partition="/",
                    format="({uf}{m}|{r:.0f}%)",
                    fmt=" {}",
                    measure="G",
                    warn_space=4,  # Warn if less than 4GB free
                    visible_on_warn=True,
                ),
                space,
                # Disk usage for home partition
                widget.DF(
                    update_interval=600,
                    partition="/home",
                    format="({uf}{m}|{r:.0f}%)",
                    fmt=" {}",
                    warn_space=20,  # Warn if less than 20GB free
                    visible_on_warn=True,
                ),
                widget.Prompt(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(),
                widget.Clock(
                    format="%A %d %B %Y %H:%M",
                ),
                # Power menu button
                widget.TextBox(
                    "⏻",
                    fontsize=20,
                    mouse_callbacks={
                        "Button1": lazy.spawn(
                            os.path.expanduser(
                                "~/.config/rofi/powermenu/type-6/powermenu.sh"
                            )
                        ),
                    },
                ),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # FIX: not work
        background=nord["background"],
        # wallpaper=logo,
        # wallpaper_mode="center",
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = True


floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="keepassxc"),  # gitk
        Match(wm_class="kdenlive"),  # gitk
        Match(wm_class="nitrogen"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)

auto_fullscreen = True
focus_on_window_activation = "focus"  # urgent, smart, focus, or None
focus_previous_on_window_remove = True
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~/.config/qtile/scripts/autostart.sh")
    subprocess.call([home])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
