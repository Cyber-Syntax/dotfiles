# TESTING: clear not used imports
from libqtile import bar, qtile
from libqtile.config import Screen

# from libqtile.lazy import lazy

import colors
from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration

# HACK: mpris2 popup is not working need to fix it later.
# from qtile_extras.popup.templates.mpris2 import COMPACT_LAYOUT, DEFAULT_LAYOUT

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

# # Pin apps to the bar
# pinned_apps = [
#     ("", "keepassxc"),
# ]
#
#
# # Textbox widget to start pinned apps
# app_widgets = [
#     widget.TextBox(
#         text=" {} ".format(app_name),
#         fontsize=16,
#         foreground="#f8f8f2",
#         background=colors[0],
#         mouse_callbacks={'Button1': lazy.spawn(app_cmd)}
#     )
#     for app_name, app_cmd in pinned_apps
# ]

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
                    tag_sensor="Tctl",
                    foreground=colors[4],
                    fmt=" {}",
                    update_interval=2,
                    threshold=60,
                    foreground_alert="ff6000",
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.NvidiaSensors(
                    # foreground="ffffff",
                    fmt=" {}",
                    format="{temp}°C {fan_speed} {perf}",
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
                    # foreground=colors[5],
                    partition="/",
                    format="{r:.0f}%",
                    fmt=" {}",
                    visible_on_warn=False,
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.DF(
                    update_interval=60,
                    # foreground=colors[5],
                    partition="/home",
                    format="{r:.0f}%",
                    fmt=" {}",
                    visible_on_warn=False,
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.DF(
                    update_interval=60,
                    # foreground=colors[5],
                    partition="/nix",
                    format="{r:.0f}%",
                    fmt=" {}",
                    visible_on_warn=False,
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.DF(
                    update_interval=60,
                    # foreground=colors[5],
                    partition="/mnt/backups",
                    format="{r:.0f}%",
                    fmt=" {}",
                    visible_on_warn=False,
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.Volume(
                    # foreground=colors[1],
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
                widget.Spacer(length=8),
                widget.Clock(
                    # foreground=colors[8],
                    format="  %A %d/%m/%y %H:%M",
                    **decoration_group,
                    # mouse_callbacks = {'Button1': lambda: qtile.spawn('gnome-calendar')},
                ),
                widget.Spacer(length=8),
                widget.Systray(
                    **decoration_group,
                ),
                widget.Spacer(length=8),
                widget.CurrentLayoutIcon(foreground=colors[1], padding=4, scale=0.6),
                # widget.TextBox(
                #     text=" ",
                #     fontsize=16,
                #     foreground="#f8f8f2",
                #     background=colors[0],
                #     mouse_callbacks={'Button1': lazy.spawn(os.path.expanduser("/home/developer/Documents/screenloyout/xrandr.sh"))}
                # ),
                # widget.Spacer(length = 8),
                # # New custom widget to call my xrandr-movie.sh script via mouse callback
                # widget.TextBox(
                #     text=" ",
                #     fontsize=16,
                #     foreground="#f8f8f2",
                #     background=colors[0],
                #     mouse_callbacks={'Button1': lazy.spawn(os.path.expanduser("~/Documents/screenloyout/xrandr-movie.sh"))}
                # ),
            ],
            size=30,  # Fix: Move the positional argument before the keyword argument
        )
    ),
    # #    # DP-0: left monitor
    #     Screen(
    #         top=bar.Bar(
    #             widgets=[
    #                 ## groups, e.g workspaces
    #                 widget.GroupBox(
    #                          #visible_groups=visible_groups,
    #                         visible_groups=['1', '3', '5'],
    #                          fontsize = 15,
    #                          margin_y = 5,
    #                          margin_x = 5,
    #                          padding_y = 0,
    #                          padding_x = 1,
    #                          borderwidth = 3,
    #                          active = colors[3],
    #                          inactive = colors[2],
    #                          rounded = True,
    #                          highlight_color = colors[0],
    #                          highlight_method = "line",
    #                          this_current_screen_border = colors[7],
    #                          this_screen_border = colors [4],
    #                          other_current_screen_border = colors[7],
    #                          other_screen_border = colors[4],
    #                         **decoration_group,
    #                          ),
    #                 widget.Spacer(length = 8),
    #                 widget.WindowTabs(
    #                     fmt = '{}',
    #                     foreground = colors[7],
    #                     separator = ' | ',
    #                     selected = ('<b><span color="#8BE9FD">   ', '</span></b>'),
    #                     **decoration_group,
    #                 ),
    #                 widget.Spacer(length = 8),
    #                 widget.Clock(
    #                         foreground = colors[8],
    #                         format = "  %A %d/%m/%y %H:%M",
    #                         mouse_callbacks = {'Button1': lambda: qtile.spawn('gnome-calendar')},
    #                         **decoration_group,
    #                         ),
    #                 widget.Spacer(length = 8),
    #                 widget.CurrentLayoutIcon(
    #                         foreground = colors[1],
    #                         padding = 4,
    #                         scale = 0.6
    #                         ),
    #             ],
    #             size=29
    #         )
    #     ),
    # #    ./end-DP-0
]

# no longer used monitor
# # HDMI-0: right monitor
# Screen(
#     top=bar.Bar(
#         widgets=[
#             widget.TextBox(
#                     text = '|',
#                     font = "Ubuntu Mono",
#                     foreground = colors[1],
#                     padding = 2,
#                     fontsize = 14
#                     ),
#             widget.WindowTabs(
#                 fmt = '{}',
#                 foreground = colors[7],
#                 separator = ' | ',
#                 selected = ('<b><span color="#8BE9FD">    ', '</span></b>'),
#             ),
#             widget.Spacer(length = 8),
#             widget.CPU(
#                     format = ' {load_percent}%',
#                     foreground = colors[4],
#                     ),
#             widget.Spacer(length = 8),
#             widget.ThermalSensor(
#                         tag_sensor='Tctl',
#                         foreground = colors[4],
#                         fmt = ' {}',
#                         update_interval = 2,
#                         threshold = 60,
#                         foreground_alert='ff6000',
#                         ),
#             widget.Spacer(length = 8),
#             widget.NvidiaSensors(
#                         foreground = 'ffffff',
#                         fmt = ' {}',
#                         update_interval = 2,
#                         threshold = 60,
#                         foreground_alert='ff6000',
#                         ),
#             widget.Spacer(length = 8),
#             widget.Memory(
#                     foreground = colors[8],
#                     measure_mem='G',
#                     #mouse_callbacks = {'Button1': lambda: qtile.spawn(terminal + ' -e htop')},
#                     format = '{MemPercent}% - {MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}',
#                     fmt = ' {}',
#                     ),
#             widget.Spacer(length = 8),
#             widget.DF(
#                     update_interval = 60,
#                     foreground = colors[5],
#                     partition = '/',
#                     format = '{r:.0f}%',
#                     fmt = ' {}',
#                     visible_on_warn = False,
#                     ),
#             widget.Spacer(length = 8),
#             widget.DF(
#                 update_interval = 60,
#                 foreground = colors[5],
#                 partition = '/home',
#                 format = '{r:.0f}%',
#                 fmt = ' {}',
#                 visible_on_warn = False,
#                 ),
#             widget.TextBox(
#                     text = '|',
#                     font = "Ubuntu Mono",
#                     foreground = colors[1],
#                     padding = 2,
#                     fontsize = 14
#             ),
#                             widget.Spacer(length = 8),
#             widget.Clock(
#                     foreground = colors[8],
#                     format = "  %A %d/%m/%y %H:%M",
#                     mouse_callbacks = {'Button1': lambda: qtile.spawn('gnome-calendar')},
#                     ),
#             widget.TextBox(
#                     text = '|',
#                     font = "Ubuntu Mono",
#                     foreground = colors[1],
#                     padding = 2,
#                     fontsize = 14
#                     ),
#             widget.CurrentLayoutIcon(
#                     foreground = colors[1],
#                     padding = 4,
#                     scale = 0.6
#                     ),
#             widget.CurrentLayout(
#                     foreground = colors[1],
#                     padding = 5
#                     ),
#             widget.TextBox(
#                     text = '|',
#                     font = "Ubuntu Mono",
#                     foreground = colors[1],
#                     padding = 2,
#                     fontsize = 14
#             ),
#         ],
#         size=20
#     )
# ),
