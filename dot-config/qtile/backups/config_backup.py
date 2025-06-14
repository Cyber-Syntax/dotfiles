# import colors

# Click([mod], "Button2", lazy.window.bring_to_front()),

# layout_theme = {
#     "border_width": 2,
#     "margin": 8,
#     "border_focus": colors[8],
#     "border_normal": colors[0],
# }

# floating_layout = layout.Floating(
#     border_focus=colors[8],
#     border_width=2,
#     # auto_float_types=[
#     #   "notification",
#     #   "toolbar",
#     #   "splash",
#     #   "dialog",
#     # ],
#     float_rules=[
#         # Run the utility of `xprop` to see the wm class and name of an X client.
#         *layout.Floating.default_float_rules,
#         Match(wm_class="keepassxc"),
#         Match(wm_class="confirmreset"),  # gitk
#         Match(wm_class="dialog"),  # dialog boxes
#         Match(wm_class="download"),  # downloads
#         Match(wm_class="error"),  # error msgs
#         Match(wm_class="file_progress"),  # file progress boxes
#         Match(wm_class="kdenlive"),  # kdenlive
#         Match(wm_class="makebranch"),  # gitk
#         Match(wm_class="maketag"),  # gitk
#         Match(wm_class="notification"),  # notifications
#         Match(wm_class="pinentry-gtk-2"),  # GPG key password entry
#         Match(wm_class="ssh-askpass"),  # ssh-askpass
#         Match(wm_class="toolbar"),  # toolbars
#         Match(wm_class="Yad"),  # yad boxes
#         Match(title="branchdialog"),  # gitk
#         Match(title="Confirmation"),  # tastyworks exit box
#         Match(title="Qalculate!"),  # qalculate-gtk
#         Match(title="pinentry"),  # GPG key password entry
#         Match(title="tastycharts"),  # tastytrade pop-out charts
#         Match(title="tastytrade"),  # tastytrade pop-out side gutter
#         # tastytrade pop-out allocation
#         Match(title="tastytrade - Portfolio Report"),
#         # tastytrade settings
#         Match(wm_class="tasty.javafx.launcher.LauncherFxApp"),
#     ],
# )


@hook.subscribe.startup_once
def start_once():
    # home = os.path.expanduser('~')
    # subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])
    # home = os.path.expanduser('~/Documents/nixos/home-manager/qtile_nixos/scripts/autostart.sh')

    home = os.path.expanduser("~/.config/qtile/scripts/autostart.sh")
    subprocess.Popen([home])
