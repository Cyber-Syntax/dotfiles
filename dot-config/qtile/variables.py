# Color Theme
# change this to change theme
# from themes import catppuccin_mocha as theme
from themes import Nord as nord_theme

# General

terminal = "kitty -d ~"
powermenu = "~/.config/rofi/powermenu/type-6/powermenu.sh"
floating_apps = ["nitrogen", "kdenlive", "keepassxc"]

layouts_margin = 1
layouts_border_width = 3
layouts_border_color = nord_theme["disabled"]
layouts_border_focus_color = nord_theme["accent"]
layouts_border_on_single = True
layouts_restore = False


# Top bar

bar_top_margin = 5
bar_bottom_margin = 5
bar_left_margin = 0
bar_right_margin = 0
bar_size = 25
bar_background_color = nord_theme["background"]
bar_foreground_color = nord_theme["foreground"]
bar_background_opacity = 0
bar_global_opacity = 1.0
bar_font = "JetbrainsMono Nerd Font"
bar_nerd_font = "JetbrainsMono Nerd Font"
bar_fontsize = 13.2

# Widgets
widget_gap = 5
widget_left_offset = 5
widget_right_offset = 5
widget_padding = 15

# Widgets Decorations
widget_decoration = "RectDecoration"

widget_decoration_border_width = 9
widget_decoration_border_color = nord_theme["accent"]
widget_decoration_border_opacity = 1.0


widget_decoration_powerline_path = "arrow_left"
widget_decoration_powerline_size = 10

widget_decoration_rect_filled = True
widget_decoration_rect_color = nord_theme["alt_background"]
widget_decoration_rect_opacity = 1.0
widget_decoration_rect_border_width = 1
widget_decoration_rect_border_color = nord_theme["accent"]
widget_decoration_rect_radius = 10

# Increasing them makes the border so close to text, so don't change below
widget_decoration_border_padding_x = 0
widget_decoration_border_padding_y = 0
widget_decoration_rect_padding_x = 0
widget_decoration_rect_padding_y = 0
widget_decoration_powerline_padding_x = 0
widget_decoration_powerline_padding_y = 0

# mod = "mod4"
# browser = None  # guess if None
# file_manager = None  # guess if None
# launcher = "rofi -show drun"
# powermenu = "rofi -show menu -modi 'menu:~/.local/share/rofi/scripts/rofi-power-menu --choices=shutdown/reboot/suspend/logout' -config ~/.config/rofi/power.rasi"
# screenshots_path = "~/Pictures/screenshots/"  # creates if doesn't exists
# layouts_saved_file = "~/.config/qtile/layouts_saved.json"  # creates if doesn't exists
# autostart_file = "~/.config/qtile/autostart.sh"
# wallpapers_path = "~/.local/share/wallpapers/"  # creates if doesn't exists
#
#
# # Uncomment the first line for qwerty, the second for azerty
# # num_keys = "123456789"
# num_keys = (
#     "ampersand",
#     "eacute",
#     "quotedbl",
#     "apostrophe",
#     "parenleft",
#     "minus",
#     "egrave",
#     "underscore",
#     "ccedilla",
#     "agrave",
# )


# # Groups
#
# groups_count = 5
# groups_labels = [
#     "●" for _ in range(groups_count)
# ]  # How the groups are named in the top bar
# # Alternatives :
# # groups_labels = [str(i) for i in range(1, groups_count + 1)]
# # groups_labels = ['what', 'ever', 'you', 'want']
#
#
# Layouts

# # Uncomment to enable layout
# layouts = [
#     "Columns",
#     # "Bsp",
#     # "RatioTile",
#     "MonadTall",
#     "MonadWide",
#     "Max",
#     # "Floating",
#     # "VerticalTile",
#     # "Stack",
#     # "Matrix",
#     # "Tile",
#     # "TreeTab",
#     # "Zoomy",
# ]
