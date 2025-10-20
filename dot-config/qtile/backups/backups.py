# config.py
# from libqtile import bar, extension, hook, layout, qtile #, widget #qtile default widget
# from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen

# keys.py
# from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
# from functions import send_left, send_right, focus_left_mon, focus_right_mon, cycle_groups, cycle_groups_reverse

# widget.py
# from libqtile import bar, extension, hook, layout, qtile
# from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen


# # 2 monitor setup
# Group("1", screen_affinity=1, matches=[Match(wm_class="superproductivity")], layout="monadtall", init=True), # DP_2: right monitor
# Group("2", screen_affinity=0, layout="monadtall", init=True), # DP-2: left monitor
# Group("3", screen_affinity=1, layout="monadtall"),
# Group("4", screen_affinity=0, layout="monadtall"),
# Group("5", screen_affinity=1, layout="monadtall"),
# Group("6", screen_affinity=0, layout="monadtall"),

## group setup ##
# widget.GroupBox(
#     # # multi monitor setup
#     # # DP-2: 2,4,6,8
#     #  visible_groups=['2', '4', '6'],
#     fontsize=15,
#     margin_y=5,
#     margin_x=5,
#     padding_y=0,
#     padding_x=1,
#     borderwidth=3,
#     active=colors[3],
#     inactive=colors[2],
#     rounded=True,
#     highlight_color=colors[0],
#     highlight_method="line",
#     this_current_screen_border=colors[7],
#     this_screen_border=colors[4],
#     other_current_screen_border=colors[7],
#     other_screen_border=colors[4],
#     disable_drag=True,
#     **decoration_group,
#     # rules = [GroupBoxRule().when(func=set_label)]
# ),
#
# Assuming you have other configurations and main loop for Qtile


# @hook.subscribe.screens_reconfigured
# async def _():
#     if len(qtile.screens) > 1:
#         groupbox1.visible_groups = ['1', '2', '3', '4', '5', '6']
#     else:
#         groupbox1.visible_groups = ['1', '2', '3', 'q', 'w', 'e']
#     if hasattr(groupbox1, 'bar'):
#         groupbox1.bar.draw()
#
# def toscreen(qtile, group_name):
#     if group_name  == qtile.current_screen.group.name:
#         return qtile.current_screen.set_group(qtile.current_screen.previous_group)
#
#     #loop through the odd(1,3,5,7) groups when DP-4 is the current screen
#     #if qtile.current_screen.group.screen_affinity == 1:
#     if qtile.current_screen.index == 1:
#         for i, group in enumerate(qtile.groups):
#             if group_name == group.name and i % 2 != 0:
#                 # focus the right screen before changing the workspace
#                 qtile.focus_screen(1)
#                 return qtile.current_screen.set_group(qtile.groups[i])
#     #loop through the even(2,4,6,8) groups when DP-2 is the current screen
#     elif qtile.current_screen.index == 0:
#         for i, group in enumerate(qtile.groups):
#             if group_name == group.name and i % 2 == 0:
#                 # focus the left screen before changing the workspace
#                 qtile.focus_screen(0)
#                 return qtile.current_screen.set_group(qtile.groups[i])

# for i, group in enumerate(qtile.groups):
# if group_name == group.name:
#     return qtile.current_screen.set_group(qtile.groups[i])
# #
# #
#
# # for i in groups:
# #     keys.append(Key([mod], i.name, lazy.function(go_to_group(i.name))))
# #     keys.append(Key([mod, "shift"], i.name, lazy.window.togroup(i.name)))
# #
#

# Assuming you have other configurations and main loop for Qtile


# def go_to_group(name: str):
#     def _inner(qtile):
#         if len(qtile.screens) == 1:
#             qtile.groups_map[name].toscreen()
#             return
#
#         start_group = qtile.current_screen.group.name
#         if start_group == name:
#             return
#         else:
#             qtile.go_to_group(name)
#
#
#         # if name in '1':
#         #     qtile.focus_screen(2) # DP-0
#         #     qtile.groups_map[name].toscreen()
#         # elif name in '2':
#         #     qtile.focus_screen(0) # DP-2
#         #     qtile.groups_map[name].toscreen()
#         # # elif name in '3':
#         # #     qtile.focus_screen(1) # HDMI-0
#         # #     qtile.groups_map[name].toscreen()
#         # else:
#         #     qtile.groups_map[name].toscreen()
#
#         return _inner
#
# for i in groups:
#     keys.append(Key([mod], i.name, lazy.function(go_to_group(i.name))))
#
#
# # Add keybindings for moving windows to groups, e.g. to move window to group 1 use mod+shift+1
# def go_to_group_and_move_window(name: str):
#     def _inner(qtile):
#         if len(qtile.screens) == 1:
#             qtile.current_window.togroup(name, switch_group=True)
#             return
#
#         # # Find screen_affinity use that index to send to the right monitor
#         # if name in '1':
#         #     qtile.current_window.togroup(name, switch_group=False)
#         #     qtile.focus_screen(2) # DP-0
#         #     qtile.groups_map[name].toscreen()
#         # elif name in '2':
#         #     qtile.current_window.togroup(name, switch_group=False)
#         #     qtile.focus_screen(0) # DP-2
#         #     qtile.groups_map[name].toscreen()
#         # # elif name in '3':
#         # #     qtile.current_window.togroup(name, switch_group=False)
#         # #     qtile.focus_screen(1) # HDMI-0
#         # #     qtile.groups_map[name].toscreen()
#         # else:
#         #     qtile.current_window.togroup(name, switch_group=True)
#
#         return _inner
#
# for i in groups:
#     keys.append(Key([mod, "shift"], i.name, lazy.function(go_to_group_and_move_window(i.name))))
#

# 2 monitor setup

# # assing screen_affinity to each screen like DP-0 = 2, DP-2 = 0
# DP_0 = 0 index
# DP_2 = 1 index


# # 1 monnitor group keybindings
# for i in groups:
#     keys.append(Key([mod], i.name, lazy.group[i.name].toscreen()) )
#     keys.append(Key([mod, "shift"], i.name, lazy.window.togroup(i.name))),

# 2 monitor group keybindings setup
# If current screen index DP-2 = 0 than mod4 + 1,3,5,7 need to focus index DP-4 = 1 before changing workspace
# If current screen index DP-4 = 1 than mod4 + 2,4,6,8 need to focus index DP-2 = 0 before changing workspace
# def toscreen(qtile, group_name):
#     if group_name  == qtile.current_screen.group.name:
#         return qtile.current_screen.set_group(qtile.current_screen.previous_group)
#     #loop through the odd(1,3,5,7) groups when DP-4 is the current screen
#     #if qtile.current_screen.group.screen_affinity == 1:
#     if qtile.current_screen.index == 1:
#         for i, group in enumerate(qtile.groups):
#             if group_name == group.name and i % 2 != 0:
#                 return qtile.current_screen.set_group(qtile.groups[i])
#     #loop through the even(2,4,6,8) groups when DP-2 is the current screen
#     else:
#         for i, group in enumerate(qtile.groups):
#             if group_name == group.name and i % 2 == 0:
#                 return qtile.current_screen.set_group(qtile.groups[i])
#     for i, group in enumerate(qtile.groups):
#         if group_name == group.name:
#             return qtile.current_screen.set_group(qtile.groups[i])
