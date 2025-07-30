"""
Laptop-specific widgets for Qtile.

This module extends the global widgets with laptop-specific additions.
"""

from libqtile import qtile
from qtile_extras import widget
import subprocess

# Import the global widget module
from global_widget import (
    colors,
    create_screen,
    decorations,
    global_left,
    global_right,
    smart_parse_text,
    space,
    widget_decoration,
)

# Define laptop-specific left widgets
# We'll extend global_left with laptop-specific TaskList
left = global_left + [
    widget.TaskList(
        border="#414868",  # border color
        highlight_method="block",
        max_title_with=80,
        txt_minimized="",
        txt_floating="",
        txt_maximized="",
        parse_text=smart_parse_text,  # Laptop uses smart parsing for window titles
        text_minimized="",
        text_maximized="",
        text_floating="",
        spacing=1,
        icon_size=20,
        border_width=0,
        fontsize=13,  # Do not change! Cause issue with specified widget_defaults
        stretch=False,
        padding_x=0,
        padding_y=0,
        hide_crash=True,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
]

# No middle widgets for laptop
middle = []

# Define laptop-specific widgets
laptop_specific_widgets = [
    # Volume with laptop-specific callbacks
    widget.Volume(
        fmt="{}",
        emoji=True,
        emoji_list=["🔇", "󰕿 ", "󰖀 ", "󰕾 "],
        fontsize=20,
        check_mute_string="[off]",
        mouse_callbacks={
            # Left click to change volume output
            "Button1": lambda: qtile.spawn(
                'kitty -- bash -c "~/.config/qtile/scripts/sink-change.sh --change"'
            ),
            # Right click to open pavucontrol
            "Button3": lambda: qtile.spawn("pavucontrol"),
        },
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    space,
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
    # Thermal sensor for CPU
    widget.ThermalSensor(
        tag_sensor="CPU",
        foreground=colors[4],
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
]

# Laptop-specific widgets to add near the end (before power button)
laptop_end_widgets = [
    widget.Battery(
        notify_below=25,
        decorations=[
            getattr(widget.decorations, widget_decoration)(
                **decorations[widget_decoration] | {"extrawidth": 4}
            )
        ],
    ),
    # space,
    # widget.Bluetooth(
    #     default_show_battery=True,
    #     default_text=" {connected_devices}",
    #     device_format=" {name}{battery_level} [{symbol}]",
    #     fontsize=20,
    # ),
    space,
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
]

# Combine the widgets:
# 1. Start with laptop-specific volume controls
# 2. Add laptop-specific end widgets right before the power button from global_right
# 3. Let the create_screen function handle the rest

# Find where the power button is in global_right
power_button_index = -1
for i, widget_item in enumerate(global_right):
    if hasattr(widget_item, "text") and getattr(widget_item, "text") == "⏻":
        power_button_index = i
        break

# If power button found, insert laptop widgets before it
# Otherwise, add them at the end
if power_button_index > 0:
    # Copy global_right up to the power button
    right = global_right[:power_button_index]
    # Insert our laptop-specific widgets at the beginning
    right = laptop_specific_widgets + right
    # Insert laptop-specific end widgets before the power button
    right += laptop_end_widgets
    # Add the power button and anything after it
    right += global_right[power_button_index:]
else:
    # No power button found, just append our widgets to global_right
    right = laptop_specific_widgets + global_right + laptop_end_widgets

# Create the screen using the helper function from global_widget
screens = [create_screen(left, right, middle)]
