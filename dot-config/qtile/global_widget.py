"""
Global widget configurations shared between all Qtile machines.

This module defines widget components and helper functions that are common to all machines,
reducing code duplication and making configuration more maintainable.
"""

import calendar
import os
import subprocess

from libqtile import bar, qtile
from libqtile.config import Screen
from libqtile.lazy import lazy
from qtile_extras import widget

import colors
from variables import (
    bar_background_color,
    bar_background_opacity,
    bar_bottom_margin,
    bar_font,
    bar_fontsize,
    bar_foreground_color,
    bar_global_opacity,
    bar_left_margin,
    bar_right_margin,
    bar_size,
    bar_top_margin,
    layouts_margin,
    nord_theme,
    widget_decoration,
    widget_decoration_border_color,
    widget_decoration_border_opacity,
    widget_decoration_border_padding_x,
    widget_decoration_border_padding_y,
    widget_decoration_border_width,
    widget_decoration_powerline_padding_x,
    widget_decoration_powerline_padding_y,
    widget_decoration_powerline_path,
    widget_decoration_powerline_size,
    widget_decoration_rect_border_color,
    widget_decoration_rect_border_width,
    widget_decoration_rect_color,
    widget_decoration_rect_opacity,
    widget_decoration_rect_padding_x,
    widget_decoration_rect_padding_y,
    widget_decoration_rect_radius,
    widget_gap,
    widget_left_offset,
    widget_padding,
    widget_right_offset,
)


# Custom calendar preview for the clock via calendar library
def calendar_preview():
    yy, mm = (
        calendar.datetime.datetime.now().year,
        calendar.datetime.datetime.now().month,
    )
    # dispaly the current moth's calendar
    month_calendar = calendar.monthcalendar(yy, mm)

    # display the calendar all year round
    year_calendar = calendar.TextCalendar().formatyear(yy, 2, 1, 1, 3)

    # display the current month in a popup
    popup_text = f"{calendar.month_name[mm]} {yy}\n\n"


# Use Nord color theme
colors = colors.Nord


# Widget tweaking utility class
class WidgetTweaker:
    def __init__(self, func):
        self.format = func


@WidgetTweaker
def currentLayout(output):
    return output.capitalize()


# Common decoration configurations for all machines
decorations = {
    "BorderDecoration": {
        "border_width": widget_decoration_border_width,
        "colour": widget_decoration_border_color
        + format(int(widget_decoration_border_opacity * 255), "02x"),
        "padding_x": widget_decoration_border_padding_x,
        "padding_y": widget_decoration_border_padding_y,
    },
    "PowerLineDecoration": {
        "path": widget_decoration_powerline_path,
        "size": widget_decoration_powerline_size,
        "padding_x": widget_decoration_powerline_padding_x,
        "padding_y": widget_decoration_powerline_padding_y,
    },
    "RectDecoration": {
        "group": True,
        "filled": True,
        "colour": widget_decoration_rect_color
        + format(int(widget_decoration_rect_opacity * 255), "02x"),
        "line_width": widget_decoration_rect_border_width,
        "line_colour": widget_decoration_rect_border_color,
        "padding_x": widget_decoration_rect_padding_x,
        "padding_y": widget_decoration_rect_padding_y,
        "radius": widget_decoration_rect_radius,
    },
}

# Global decoration configuration
decoration = [
    getattr(widget.decorations, widget_decoration)(**decorations[widget_decoration])
]

# Default widget settings
widget_defaults = dict(
    font=bar_font,
    foreground=bar_foreground_color,
    fontsize=bar_fontsize,
    padding=widget_padding,
    decorations=decoration,
)

extension_defaults = widget_defaults.copy()

# Common widget components
sep = [widget.WindowName(foreground="#00000000", fmt="", decorations=[])]
left_offset = [widget.Spacer(length=widget_left_offset, decorations=[])]
right_offset = [widget.Spacer(length=widget_right_offset, decorations=[])]
space = widget.Spacer(length=widget_gap, decorations=[])


# Text parsing functions
def smart_parse_text(text):
    """
    Display shortened text for applications with icons,
    and full text for applications without icons.
    """
    # List of applications with working icons
    apps_with_icons = [
        "firefox",
        "chromium",
        "chrome",
        "nemo",
        "nautilus",
        "kitty",
        "terminal",
        "brave",
        "librewolf",
    ]

    # List of applications without working icons that need text
    apps_without_icons = ["zed", "some-other-app"]

    # Clean up common suffixes
    for suffix in [
        " - Firefox",
        " - Chromium",
        " - Mozilla Firefox",
        " — Mozilla Firefox",
    ]:
        text = text.replace(suffix, "")

    original_text = text

    # Check if this window belongs to an app that has a working icon
    for app in apps_with_icons:
        if app.lower() in text.lower():
            # Shorten text instead of hiding it completely
            app_name = app.capitalize()

            # Extract the page title or document name
            if ":" in text:
                # For titles with format "App: Document"
                title = text.split(":", 1)[1].strip()
            else:
                title = text.replace(app, "").replace(app.capitalize(), "").strip()

            # Create a shortened version
            if title:
                short_title = title[:12] + "..." if len(title) > 15 else title
                return short_title
            else:
                return app_name

    # Check if this is an app we know doesn't have a working icon
    for app in apps_without_icons:
        if app.lower() in text.lower():
            return original_text  # Show full text since icon doesn't work

    # Default: return shortened text for other applications
    if len(text) > 30:
        return text[:27] + "..."
    return text


def no_text(text):
    """Hide all window titles completely."""
    return ""


def get_appimage_updates():
    import subprocess

    try:
        out = subprocess.check_output(
            [
                "/bin/bash",
                "/home/developer/.local/share/my-unicorn/scripts/update.bash",
                "--check",
            ],
            stderr=subprocess.STDOUT,
            timeout=10,
        )
        return out.decode().strip()
    except subprocess.CalledProcessError as e:
        return e.output.decode().strip() or f"Exit {e.returncode}"
    except Exception as e:
        return f"Error: {e}"


# Common left widgets for all machines
global_left = [
    # GroupBox is identical on both desktop and laptop
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

# Common right widgets for all machines
global_right = [
    # Custom appimage updates script call
    widget.GenPollText(
        name="my-unicorn",
        func=get_appimage_updates,
        update_interval=9600,  # Update every 2 hours
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
    # Custom fedora package manager script call
    widget.GenPollText(
        name="fedora-package-manager",
        func=lambda: subprocess.check_output(
            "/home/developer/.local/share/linux-system-utils/package-management/fedora-package-manager.sh --status",
            timeout=225,
            shell=True,
        )
        .decode("utf-8")
        .strip(),
        update_interval=9600,  # Update every 2 hours
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
    # Common disk usage widgets
    widget.DF(
        update_interval=600,
        partition="/",
        format="({uf}{m}|{r:.0f}%)",
        fmt=" {}",
        measure="G",  # G,M,B
        warn_space=4,  # warn if only 5GB or less space left
        visible_on_warn=True,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    widget.DF(
        update_interval=600,
        partition="/home",
        format="({uf}{m}|{r:.0f}%)",
        fmt=" {}",
        warn_space=20,
        visible_on_warn=True,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # Clock widget is identical
    widget.Clock(
        format="%A %d %B %Y %H:%M",
        # mouse_callbacks={"Button1": lambda: qtile.spawn("gnome-calendar")},
        # lets use the library calendar instead
        # mouse_callbacks={"Button1": lazy.group["scratchpad"].dropdown_toggle("khal")},
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # System tray is identical
    widget.Systray(
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # Power menu button is identical
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


# Common screen configuration function
def create_screen(widgets_left, widgets_right, widgets_middle=None):
    """Create a screen with the given widgets."""
    if widgets_middle is None:
        widgets_middle = []

    return Screen(
        top=bar.Bar(
            widgets=left_offset
            + widgets_left
            + sep
            + widgets_middle
            + sep
            + widgets_right
            + right_offset,
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
        ),
    )
