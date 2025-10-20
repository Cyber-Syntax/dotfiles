"""
Shared widget utilities and helper functions for Qtile configuration.

This module provides common utilities that can be imported by both desktop
and laptop widget configurations. It does NOT define actual widget lists
to keep things simple and explicit.

IMPORTANT: For better maintainability, actual widget configurations should be
defined explicitly in widget.py (desktop) and laptopWidget.py (laptop).
"""

from qtile_extras import widget

import themes
from functions import (
    get_appimage_updates,
    get_fedora_updates,
    no_text,
    smart_parse_text,
)
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

# Use Nord color theme
nord_theme = themes.Nord


# ============================================================================
# Widget Decoration Configurations
# ============================================================================

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

# Global decoration configuration applied to widgets by default
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


# ============================================================================
# Common Widget Components (Spacers and Separators)
# ============================================================================

# Invisible separator for flexible spacing between widget groups
flexible_spacing_seperator = [
    widget.WindowName(foreground="#00000000", fmt="", decorations=[])
]

# Bar edge offsets
left_offset = [widget.Spacer(length=widget_left_offset, decorations=[])]
right_offset = [widget.Spacer(length=widget_right_offset, decorations=[])]

# Standard spacing between widgets
space = widget.Spacer(length=widget_gap, decorations=[])


# ============================================================================
# Bar Configuration Values (Re-exported for convenience)
# ============================================================================

# These are re-exported so widget modules can import everything from one place
__all__ = [
    # Theme colors
    "nord_theme",
    # Decoration configs
    "decorations",
    "decoration",
    "widget_decoration",
    # Widget defaults
    "widget_defaults",
    "extension_defaults",
    # Common components
    "flexible_spacing_seperator",
    "left_offset",
    "right_offset",
    "space",
    # Helper functions
    "smart_parse_text",
    "no_text",
    "get_appimage_updates",
    "get_fedora_updates",
    # Bar configuration values
    "bar_background_color",
    "bar_background_opacity",
    "bar_bottom_margin",
    "bar_font",
    "bar_fontsize",
    "bar_foreground_color",
    "bar_global_opacity",
    "bar_left_margin",
    "bar_right_margin",
    "bar_size",
    "bar_top_margin",
    "layouts_margin",
]
