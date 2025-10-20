"""
Desktop-specific widgets for Qtile.

This module extends the global widgets with desktop-specific additions.
"""

import os
import subprocess
import gi
from libqtile import bar, qtile
from libqtile.config import Screen
from libqtile.lazy import lazy
from qtile_extras import widget
from qtile_extras.popup.toolkit import (
    PopupRelativeLayout,
    PopupSlider,
    PopupText,
)

# Add GTK dependencies
try:
    gi.require_version("Gtk", "3.0")
    from gi.repository import Gtk

    GTK_THEME = Gtk.Settings.get_default().get_property("gtk-icon-theme-name")
    GTK_THEME_AVAILABLE = True
except (ImportError, ValueError):
    GTK_THEME = None
    GTK_THEME_AVAILABLE = False
    print("Warning: Could not load GTK, falling back to default icon theme")

# Import the terminal variable from variables.py
from variables import terminal

# Import all the shared widget configurations
from global_widget import (
    colors,
    decoration,
    decorations,
    extension_defaults,
    flexible_spacing_seperator,
    smart_parse_text,
    space,
    widget_defaults,
    widget_decoration,
    widget_decoration_border_width,
    widget_decoration_border_color,
    widget_decoration_border_opacity,
    widget_decoration_border_padding_x,
    widget_decoration_border_padding_y,
    widget_decoration_powerline_path,
    widget_decoration_powerline_size,
    widget_decoration_powerline_padding_x,
    widget_decoration_powerline_padding_y,
    widget_decoration_rect_color,
    widget_decoration_rect_opacity,
    widget_decoration_rect_border_width,
    widget_decoration_rect_border_color,
    widget_decoration_rect_padding_x,
    widget_decoration_rect_padding_y,
    widget_decoration_rect_radius,
    bar_font,
    bar_foreground_color,
    bar_fontsize,
    widget_padding,
    widget_left_offset,
    widget_right_offset,
    widget_gap,
    bar_size,
    bar_background_color,
    bar_background_opacity,
    bar_top_margin,
    bar_right_margin,
    bar_bottom_margin,
    bar_left_margin,
    layouts_margin,
    nord_theme,
    bar_global_opacity,
    left_offset,
    right_offset,
)

# qtile extras setup
VOLUME_NOTIFICATION = PopupRelativeLayout(
    width=200,
    height=50,
    hide_on_mouse_leave=True,
    controls=[
        PopupText(
            text="Volume:",
            name="text",
            pos_x=0.1,
            pos_y=0.1,
            height=0.2,
            width=0.8,
            v_align="middle",
            h_align="center",
        ),
        PopupSlider(
            name="volume",
            pos_x=0.1,
            pos_y=0.3,
            width=0.8,
            height=0.8,
            colour_below="00ffff",
            bar_border_size=2,
            bar_border_margin=1,
            bar_size=4,
            marker_size=0,
            end_margin=0,
        ),
    ],
)
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


left = [
    # "pyxdg" package is needed for wayland for TaskList
    widget.GroupBox(
        font=f"{bar_font} Bold",
        disable_drag=True,
        borderwidth=0,
        fontsize=15,
        inactive=nord_theme["disabled"],
        active=bar_foreground_color,
        block_highlight_text_color=nord_theme["accent"],
        padding=7,
    ),
    space,
    widget.TaskList(
        border="#414868",  # border clour
        highlight_method="block",
        max_title_with=80,
        txt_minimized="",
        txt_floating="",
        txt_maximized="",
        parse_text=smart_parse_text,
        spacing=1,
        icon_size=25,
        border_width=0,
        fontsize=13,  # Do not change! Cause issue with specified widget_defaults
        stretch=False,
        padding_x=1,
        padding_y=1,
        hide_crash=True,
        # theme_mode="preferred",
        # theme_mode='fallback', #FIX: not work currently
        theme_path=[
            "~/.local/share/icons/",
            "~/.local/share/flatpak/exports/share/icons/",  # Flatpak user icons
            "/var/lib/flatpak/exports/share/icons/",  # Flatpak system icons
        ],
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # TODO: define default apps, handle groups not find problem
    #    default_apps = ["firefox", "code", "nemo", None, None, "firefox", None, "discord", "pavucontrol", "terminator -e bpytop",]
    # widget.TextBox(
    #     " ",
    #     fontsize=20,
    #     decorations=[
    #         getattr(widget.decorations, widget_decoration)(
    #             **decorations[widget_decoration] | {"extrawidth": 3}
    #         )
    #     ],
    #     mouse_callbacks={
    #         "Button1": lazy.function(
    #             spawn_default_app, groups, default_apps, unset_default_app=run_launcher
    #         ),
    #     },
    # ),
]
middle = []

right = [
    space,
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
        # mouse_callbacks={"Button3": lazy.function(widget.select_sink)},
    ),
    space,
    widget.Mpris2(
        fmt="{}",
        format=" {xesam:title} - {xesam:artist}",
        paused_text="  {track}",
        playing_text="  {track}",
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
    widget.ThermalSensor(
        tag_sensor="Tctl",
        foreground=colors[4],
        fmt=" {}",
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
    widget.NvidiaSensors(
        fmt=" {}",
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
    widget.DF(
        update_interval=60,
        partition="/",
        format="({uf}{m}|{r:.0f}%)",
        fmt=" {}",
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
        update_interval=60,
        partition="/home",
        format="({uf}{m}|{r:.0f}%)",
        fmt=" {}",
        warn_space=20,
        visible_on_warn=True,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    widget.DF(
        update_interval=60,
        partition="/mnt/backups",
        format="({uf}{m}|{r:.0f}%)",
        fmt=" {}",
        warn_space=10,
        visible_on_warn=True,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    widget.GenPollText(
        func=lambda: subprocess.check_output(
            "/home/developer/.config/qtile/scripts/fedora-flatpak-status.sh",
            timeout=15,
            shell=True,
        )
        .decode("utf-8")
        .strip(),
        update_interval=3600,  # Update every 60 minutes
        mouse_callbacks={
            "Button1": lambda: qtile.spawn(
                'kitty -- bash -c "/home/developer/.config/qtile/scripts/update-dnf-flatpak.sh"'
            ),
        },
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    widget.Clock(
        format="%A %d %B %Y %H:%M",
        mouse_callbacks={"Button1": lambda: qtile.spawn("gnome-calendar")},
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    # widget.StatusNotifier(),
    # NOTE: Systray would not able to handle transparent background some of the apps.
    widget.Systray(
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    widget.CurrentLayoutIcon(
        padding=10,
        scale=0.6,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
    widget.TextBox(
        "⏻",
        fontsize=20,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 3}
            )
        ],
        mouse_callbacks={
            # "Button1": lazy.spawn(powermenu)
            "Button1": lazy.spawn(
                os.path.expanduser("~/.config/rofi/powermenu/type-6/powermenu.sh")
            ),
        },
    ),
    space,
]

screens = [
    Screen(
        top=bar.Bar(
            widgets=left_offset + left + flexible_spacing_seperator + middle + flexible_spacing_seperator + right + right_offset,
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
    ),
]
