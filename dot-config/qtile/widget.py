"""
Desktop widget configuration for Qtile (Two-monitor setup).

Monitor Layout:
- Left Monitor: GroupBox + TaskList for workspace/app management
- Right Monitor: System widgets (updates, sensors, clock, systray, etc.)

NOTE: Systray can only appear once, so it goes on the right monitor.
"""

import os


# Import shared utilities
from global_widget import (
    bar_background_color,
    bar_background_opacity,
    bar_bottom_margin,
    bar_font,
    bar_foreground_color,
    bar_global_opacity,
    bar_left_margin,
    bar_right_margin,
    bar_size,
    bar_top_margin,
    decorations,
    flexible_spacing_seperator,
    get_appimage_updates,
    get_fedora_updates,
    layouts_margin,
    left_offset,
    nord_theme,
    right_offset,
    smart_parse_text,
    space,
    widget_decoration,
)
from libqtile import bar, qtile
from libqtile.config import Screen
from libqtile.lazy import lazy
from qtile_extras import widget
from variables import terminal
# from functions import num_monitors

# ============================================================================
# LEFT MONITOR WIDGETS (Monitor 0)
# ============================================================================

left_monitor_widgets = [
    # GroupBox showing only specific workspaces for this monitor
    widget.GroupBox(
        font=f"{bar_font} Bold",
        visible_groups=["1", "3", "5"],  # Workspaces for left monitor
        disable_drag=True,
        borderwidth=0,
        fontsize=15,
        highlight_method="line",
        inactive=nord_theme["disabled"],
        active=bar_foreground_color,
        block_highlight_text_color=nord_theme["accent"],
        padding=7,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # TaskList showing all open applications
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
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
]


# ============================================================================
# RIGHT MONITOR WIDGETS (Monitor 1)
# ============================================================================

right_monitor_middle = [
    # TaskList and GroupBox separator
    # GroupBox for right monitor workspaces
    widget.GroupBox(
        font=f"{bar_font} Bold",
        visible_groups=["2", "4", "6"],  # Workspaces for right monitor
        disable_drag=True,
        borderwidth=0,
        fontsize=15,
        highlight_method="line",
        inactive=nord_theme["disabled"],
        active=bar_foreground_color,
        block_highlight_text_color=nord_theme["accent"],
        padding=7,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # TaskList showing all open applications
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
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
]

right_monitor_widgets = [
    # System monitoring widgets (only on right monitor to avoid duplication)
    widget.UnitStatus(
        label="trash-cli",
        unitname="trash-cli.service",
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    widget.UnitStatus(
        label="borg",
        unitname="borgbackup-home.service",
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    widget.UnitStatus(
        label="ollama",
        unitname="ollama.service",
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # Volume control
    widget.PulseVolumeExtra(
        fmt="{}",
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
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
        foreground=nord_theme["warning"],
        fmt="🌡️ {}",
        update_interval=2,
        threshold=60,
        foreground_alert="ff6000",
        mouse_callbacks={
            "Button1": lambda: qtile.spawn(terminal + " htop"),
            "Button3": lambda: qtile.spawn(terminal + " btop"),
        },
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
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
            "Button1": lambda: qtile.spawn(terminal + " watch -n 2 'nvidia-smi'")
        },
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
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
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
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
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
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
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
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
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
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
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # Clock widget
    widget.Clock(
        format="%A %d %B %Y %H:%M",
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # System tray (IMPORTANT: Can only be on ONE monitor)
    widget.Systray(
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # Power menu button
    widget.TextBox(
        "⏻",
        fontsize=20,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 3}
            )
        ],
        mouse_callbacks={
            "Button1": lazy.spawn(
                os.path.expanduser("~/.config/rofi/powermenu/type-6/powermenu.sh")
            ),
        },
    ),
    space,
]


# ============================================================================
# Screen Configuration for Two Monitors
# ============================================================================


def create_bar(widgets: list) -> bar.Bar:
    """
    Create a bar with consistent styling.

    Args:
        widgets: List of widget instances to display in the bar

    Returns:
        Configured bar.Bar instance
    """
    return bar.Bar(
        widgets=widgets,
        size=bar_size,
        background=bar_background_color
        + format(int(bar_background_opacity * 255), "02x"),
        margin=[
            bar_top_margin,
            bar_right_margin,
            bar_bottom_margin - layouts_margin,
            bar_left_margin,
        ],
        opacity=bar_global_opacity,
    )


# Define screens for both monitors
# flexible_spacing_seperator: separator between tasklist and right monitor widgets.
# Example like below:
# tasklist                                                   right monitor widgets.
#

# FIXME: primary monitor is DP-2 but this use DP-0..
# screens = [
#     # Right Monitor (Primary) - System information + Systray
#     Screen(
#         top=create_bar(
#             left_offset
#             + right_monitor_middle
#             + flexible_spacing_seperator
#             + right_monitor_widgets
#             + right_offset
#         ),
#     ),
# ]
#
# if num_monitors > 1:
#     for m in range(num_monitors - 1):
#         screens.append(
#             # Left Monitor (Secondary) - Workspace management + TaskList
#             Screen(
#                 top=create_bar(left_offset + left_monitor_widgets + right_offset),
#             ),
#         )
#

screens = [
    # Right Monitor (Primary) - System information + Systray
    Screen(
        top=create_bar(
            left_offset
            + right_monitor_middle
            + flexible_spacing_seperator
            + right_monitor_widgets
            + right_offset
        ),
    ),
    # Left Monitor (Secondary) - Workspace management + TaskList
    Screen(
        top=create_bar(left_offset + left_monitor_widgets + right_offset),
    ),
]
