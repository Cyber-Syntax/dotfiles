# TODO: use variables module
# add all of the variables withou wildcard imports
# terminal_hold = "kitty -d --hold"  # Default terminal
# Scratchpad
# groups.append(
#     ScratchPad(
#         "scratchpad",
#         [
#             DropDown(
#                 "khal",
#                 terminal_hold + "khal calendar",
#                 x=0.6785,
#                 width=0.32,
#                 height=0.997,
#                 opacity=1,
#             ),
#             # define a drop down terminal.
#             # it is placed in the upper third of screen by default.
#             DropDown(  # F10
#                 "term",
#                 # HACK:
#                 "kitty -d ~",
#                 opacity=0.8,
#                 width=0.5,
#                 height=0.5,
#                 x=0.3,
#                 y=0.3,
#                 # on_focus_lost_hide=False,  # Keep open until manually hidden
#             ),
#             # DropDown(  # F11
#             #     "social",
#             #     "/home/developer/Documents/appimages/FreeTube.AppImage",
#             #     opacity=0.8,
#             #     width=0.5,
#             #     height=0.5,
#             #     x=0.3,
#             #     y=0.3,
#             #     # on_focus_lost_hide=False,  # Keep open until manually hidden
#             # ),
#             DropDown(  # F12
#                 "chat",
#                 "signal-desktop",
#                 opacity=0.8,
#                 width=0.5,
#                 height=0.5,
#                 x=0.3,
#                 y=0.3,
#                 # on_focus_lost_hide=False,  # Keep open until manually hidden
#             ),
#         ],
#     ),
# )