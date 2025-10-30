"""
Laptop widget configuration for Qtile (Single monitor setup).

Monitor Layout:
- Single Monitor: GroupBox + TaskList + All system widgets

This configuration combines workspace management and system information
on a single screen for laptop use.
"""

import os

from libqtile import bar, qtile
from libqtile.config import Screen
from libqtile.lazy import lazy
from qtile_extras import widget

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

# ============================================================================
# LAPTOP LEFT WIDGETS - Workspace Management
# ============================================================================

left = [
    # GroupBox showing all workspaces (laptop uses all on one screen)
    widget.GroupBox(
        font=f"{bar_font} Bold",
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
]


# ============================================================================
# LAPTOP MIDDLE WIDGETS - TaskList
# ============================================================================

middle = [
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
# LAPTOP RIGHT WIDGETS - System Information
# ============================================================================

right = [
    # Laptop-specific volume widget with emoji indicators
    widget.Bluetooth(
        fmt="<i> {}</i>",
        fontsize=15,
        default_text="{connected_devices}",
        default_show_battery=True,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    widget.Volume(
        fmt=" {}",
        emoji=True,
        emoji_list=["🔇", "󰕿 ", "󰖀 ", "󰕾 "],
        fontsize=20,
        check_mute_string="[off]",
        mouse_callbacks={
            "Button1": lambda: qtile.spawn(
                'kitty -- bash -c "~/.config/qtile/scripts/sink-change.sh --change"'
            ),
            "Button3": lambda: qtile.spawn("pavucontrol"),
        },
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # Extended volume control
    widget.PulseVolumeExtra(
        limit_normal=80,
        limit_high=100,
        limit_loud=101,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    widget.CPU(
        format="{freq_current}GHz {load_percent}%",
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # CPU temperature sensor
    widget.ThermalSensor(
        tag_sensor="CPU",
        foreground=nord_theme["warning"],
        fmt=" {}",
        update_interval=1,
        threshold=60,
        foreground_alert="ff6000",
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
    # Battery indicator (laptop-specific)
    widget.Battery(
        format="{char} {percent:2.0%} | {hour:d}h {min:02d}m | {watt:.2f}W",
        charge_char=" ",
        discharge_char="🚨",
        not_charging_char="",
        notify_below=25,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # Screen backlight control (laptop-specific)
    widget.Backlight(
        fmt="🔆 {}",
        backlight_name="intel_backlight",
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
    # System tray
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
# Screen Configuration for Single Monitor (Laptop)
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


# Single screen for laptop
screens = [
    Screen(
        top=create_bar(
            left_offset
            + left
            # + flexible_spacing_seperator
            + middle
            + flexible_spacing_seperator
            + right
            + right_offset
        ),
    ),
]
