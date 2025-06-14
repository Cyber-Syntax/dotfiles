from libqtile import bar, qtile
from libqtile.config import Screen
from libqtile.lazy import lazy
import colors
from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration

from variables import *

# HACK: mpris2 popup is not working need to fix it later.
# from qtile_extras.popup.templates.mpris2 import COMPACT_LAYOUT, DEFAULT_LAYOUT

# FIXME: widget need dbus-next library. Systray eror after UPowerWidget added
# error about 2 systray won't work together...
# hooks from qtile-extras for UPowerWidget
from libqtile import qtile

import qtile_extras.hook


@qtile_extras.hook.subscribe.up_power_disconnected
def unplugged():
    qtile.spawn("ffplay power_off.wav")


@qtile_extras.hook.subscribe.up_power_connected
def plugged_in():
    qtile.spawn("ffplay power_on.wav")


@qtile_extras.hook.subscribe.up_battery_full
def battery_full(battery_name):
    send_notification(battery_name, "Battery is fully charged.")


@qtile_extras.hook.subscribe.up_battery_low
def battery_low(battery_name):
    send_notification(battery_name, "Battery is running low.")


@qtile_extras.hook.subscribe.up_battery_critical
def battery_critical(battery_name):
    send_notification(battery_name, "Battery is critically low. Plug in power supply.")


# ./hooks from qtile-extras

colors = colors.Nord

# Defaul widget settings
widget_defaults = dict(
    font="JetBrains Mono Bold",
    fontsize=16,
    foreground=colors[1],
    background=colors[0],
    padding=1,
)

extension_defaults = widget_defaults.copy()

# qtile-extras definitions
decoration_group = {
    "decorations": [
        RectDecoration(
            colour="#181825", radius=10, filled=True, padding_y=4, group=True
        )
    ],
    "padding": 3,
}

# Pin apps to the bar
pinned_apps = [
    ("", "keepassxc"),
]


# Textbox widget to start pinned apps
app_widgets = [
    widget.TextBox(
        text=" {} ".format(app_name),
        fontsize=16,
        foreground="#f8f8f2",
        background=colors[0],
        mouse_callbacks={"Button1": lazy.spawn(app_cmd)},
    )
    for app_name, app_cmd in pinned_apps
]

## Screens ##
screens = [
    # Primary monitor
    Screen(
        top=bar.Bar(
            widgets=[
                # *app_widgets,
                widget.Spacer(length=8),
                widget.GroupBox(
                    # # multi monitor setup
                    # # DP-2: 2,4,6,8
                    #  visible_groups=['2', '4', '6'],
                    fontsize=15,
                    margin_y=5,
                    margin_x=5,
                    padding_y=0,
                    padding_x=1,
                    borderwidth=3,
                    active=colors[3],
                    inactive=colors[2],
                    rounded=True,
                    highlight_color=colors[0],
                    highlight_method="line",
                    this_current_screen_border=colors[7],
                    this_screen_border=colors[4],
                    other_current_screen_border=colors[7],
                    other_screen_border=colors[4],
                    **decoration_group,
                    # rules = [GroupBoxRule().when(func=set_label)]
                ),
                widget.Spacer(length=8),
                widget.TaskList(
                    highlight_method="block",
                    foreground=colors[1],
                    background=colors[0],
                    max_title_with=80,
                    txt_minimized="",
                    txt_floating="",
                    txt_maximized="",
                    # get only app names
                    # parse_text=lambda text: '|' + text,
                    spacing=20,
                    icon_size=20,
                    border_width=0,
                ),
                widget.Spacer(length=8),
                widget.Mpris2(
                    fmt="{}",
                    format="{xesam:title} - {xesam:artist}",
                    foreground=colors[7],
                    paused_text=" {track}",
                    playing_text=" {track}",
                    scroll_fixed_width=False,
                    max_chars=200,
                    separator=", ",
                    stopped_text="",
                    width=200,
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.ThermalSensor(
                    tag_sensor="CPU",
                    foreground=colors[4],
                    fmt=" {}",
                    update_interval=2,
                    threshold=60,
                    foreground_alert="ff6000",
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                # widget.Memory(
                #         foreground = colors[8],
                #         measure_mem='G',
                #         #mouse_callbacks = {'Button1': lambda: qtile.spawn(terminal + ' -e htop')},
                #         format = '{MemUsed:.0f}{mm}/{MemTotal:.0f}{mm}',
                #         fmt = ' {}',
                #         **decoration_group,
                #         ),
                widget.Spacer(length=8),
                widget.DF(
                    update_interval=60,
                    foreground=colors[5],
                    partition="/",
                    format="{r:.0f}%",
                    fmt=" {}",
                    visible_on_warn=False,
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.DF(
                    update_interval=60,
                    foreground=colors[5],
                    partition="/home",
                    format="{r:.0f}%",
                    fmt=" {}",
                    visible_on_warn=False,
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.DF(
                    update_interval=60,
                    foreground=colors[5],
                    partition="/nix",
                    format="{r:.0f}%",
                    fmt=" {}",
                    visible_on_warn=False,
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.DF(
                    update_interval=60,
                    foreground=colors[5],
                    partition="/backup",
                    format="{r:.0f}%",
                    fmt=" {}",
                    visible_on_warn=False,
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.Clock(
                    foreground=colors[8],
                    format="  %A %d/%m/%y %H:%M",
                    **decoration_group,
                    # mouse_callbacks = {'Button1': lambda: qtile.spawn('gnome-calendar')},
                ),
                widget.Spacer(length=8),
                widget.BatteryIcon(
                    theme_path="/home/developer/.config/qtile/icons/battery",
                    update_interval=60,
                    **decoration_group,
                ),
                widget.Battery(
                    format="{percent:2.0%} {hour:d}:{min:02d}",
                    update_interval=60,
                    low_foreground=colors[4],
                    low_background=colors[0],
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.Volume(
                    foreground=colors[1],
                    fmt="{}",
                    emoji=True,
                    theme_path="/home/developer/.config/qtile/icons/volume",
                    check_mute_string="[off]",  # '' icon not working
                    mouse_callbacks={
                        # Left click to change volume output
                        "Button1": lambda: qtile.spawn(
                            'kitty -- bash -c "~/.config/qtile/scripts/sink-change.sh --change"'
                        ),
                        # Right click to open pavucontrol
                        "Button3": lambda: qtile.spawn("pavucontrol"),
                    },
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.PulseVolumeExtra(
                    theme_path="/home/developer/.config/qtile/icons/volume",
                    limit_normal=80,
                    limit_high=100,
                    limit_loud=101,
                    **decoration_group,
                ),
                # widget.UPowerWidget(
                #         **decoration_group,
                #         ),
                widget.Spacer(length=8),
                widget.Systray(
                    icon_size=28,
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.CurrentLayoutIcon(foreground=colors[1], padding=4, scale=0.6),
            ],
            size=30,  # Fix: Move the positional argument before the keyword argument
        )
    ),
]
