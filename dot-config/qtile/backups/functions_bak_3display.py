from libqtile.lazy import lazy

# qtile cmd-obj -o group 4 -f toscreen # focus from command line

#
# @hook.subscribe.resume
# def lock_on_resume():
#     subprocess.run(["i3lock"])  # Use list form for safer execution
#     logger.warning("Resuming from sleep")  # Changed to warning() from deprecated warn()
#
# @hook.subscribe.client_new
# def idle_dialogues(window):
#     # Use window.name instead of window.window.get_name()
#     if window.name in {"Search Dialog", "Module", "Goto", "IDLE Preferences"}:
#         window.floating = True

# @hook.subscribe.client_new
# def floating_dialogs(window):
#     # Use Qtile's window properties instead of X11 direct access
#     #FIX: AttributeError: <class 'libqtile.backend.x11.window.Window'> has no attribute wm_type
#     dialog = "dialog" in window.wm_type  # Check if dialog is in WM_TYPE
#     transient = window.transient_for()  # Check for transient parent
#     if dialog or transient:
#         window.floating = True

# APP = "superproductivity"

# @hook.subscribe.client_urgent_hint_changed
# def follow_url(client: Window) -> None:
#     """If superproductivity is flagged as urgent, focus it"""
#
#     wm_class: list | None = client.get_wm_class()
#
#     for item in wm_class:
#         match item:
#             case item if item.lower() in APP and client.group is not None:
#                 qtile.current_screen.set_group(client.group)
#                 client.group.focus(client)
#                 return

# 2 monitor setup
DP_0 = 0
DP_0 = 1

# 2 monitor group keybindings


def go_to_group(name: str):
    def _inner(qtile):
        if len(qtile.screens) == 1:
            qtile.groups_map[name].toscreen()
            return
        start_group = qtile.current_screen.group.name
        if start_group == name:
            return
        else:
            qtile.go_to_group(name)
        return _inner


def toscreen(qtile, group_name):
    current_screen_index = qtile.current_screen.index
    print(f"Current screen index: {current_screen_index}")

    # Determine the correct group index based on current screen index
    if current_screen_index == 0:  # Left monitor (index 0)
        # Convert workspace number to group index
        group_index = int(group_name[-1]) * 2
    elif current_screen_index == 1:  # Right monitor (index 1)
        # Convert workspace number to group index
        group_index = int(group_name[-1]) * 2 - 1
    else:
        print("Invalid screen index!")
        return

    # Focus the correct screen before changing the workspace
    qtile.focus_screen(current_screen_index)

    # Set the group to the corresponding workspace index
    if 0 <= group_index < len(qtile.groups):
        qtile.current_screen.set_group(qtile.groups[group_index])
    else:
        print(f"Group index {group_index} is out of range!")


@lazy.function
def send_left(qtile):
    """Send the current window to the left screen."""
    # Find screen_affinity use that index to send to the right monitor
    # screen_affinity = qtile.current_screen.group.screen_affinity
    #
    if qtile.current_screen.index == DP_2:
        qtile.current_window.togroup(qtile.screens[0].group.name, switch_group=False)
        qtile.focus_screen(0)


# if screen_affinity == 2: # DP-2
#     qtile.current_window.togroup(qtile.screens[1].group.name, switch_group=False)
#     qtile.focus_screen(1)
# elif screen_affinity == 0: # DP-0
#     qtile.current_window.togroup(qtile.screens[2].group.name, switch_group=False)
#     qtile.focus_screen(2)
# else:                       # DP_2
#     qtile.current_window.togroup(qtile.screens[0].group.name, switch_group=False)
#     qtile.focus_screen(0)
#


@lazy.function
def send_right(qtile):
    """Send the current window to the right monitor"""
    # screen_affinity = qtile.current_screen.group.screen_affinity
    #

    if qtile.current_screen.index == DP_0:
        qtile.current_window.togroup(qtile.screens[1].group.name, switch_group=False)
        qtile.focus_screen(1)

    # 3 monitor setup
    # if screen_affinity == 2: # DP-0
    #     qtile.current_window.togroup(qtile.screens[0].group.name, switch_group=False)
    #     # Focus can't stay on window when sending from DP-0 to DP-2 when layout isn't max.
    #     qtile.focus_screen(0)
    # elif screen_affinity == 0: # DP-2
    #     qtile.current_window.togroup(qtile.screens[1].group.name, switch_group=False)
    #     qtile.focus_screen(1)
    # else:                       # DP_2
    #     qtile.current_window.togroup(qtile.screens[0].group.name, switch_group=False)
    #     qtile.focus_screen(0)


@lazy.function
def focus_left_mon(qtile):
    """Focus dp-0 left monitor"""
    if len(qtile.screens) == 1:
        qtile.focus_screen(qtile.current_screen.previous_group)
        return

    screen_affinity = qtile.current_screen.group.screen_affinity

    if qtile.current_screen.index == 1:
        qtile.focus_screen(0)

    # if qtile.current_screen.index == 0:
    #     qtile.focus_screen(2)
    # elif qtile.current_screen.index == 1:
    #     qtile.focus_screen(0)
    # else:
    #     qtile.focus_screen(qtile.current_screen.previous_group)
    #


@lazy.function
def focus_right_mon(qtile):
    """Focus dp-2 right monitor"""
    if len(qtile.screens) == 1:
        qtile.focus_screen(qtile.current_screen.next_group)
        return

    screen_affinity = qtile.current_screen.group.screen_affinity

    if qtile.current_screen.index == 0:
        qtile.focus_screen(1)

    # if qtile.current_screen.index == 2:
    #     qtile.focus_screen(0)
    # elif qtile.current_screen.index == 0:
    #     qtile.focus_screen(1)
    # else:
    #     qtile.focus_screen(qtile.current_screen.next_group)
    #


## ./2 monitor setup ##

# Common group functions

# NOTE: not used anymore, above already handle it with (skip=True)
# @lazy.function
# def cycle_groups(qtile):
#     """Cycle through the groups but only the odd or even groups"""
#     current_group_index = qtile.groups.index(qtile.current_group)
#     next_group_index = current_group_index
#
#     # Check if the current group name is odd or even
#     current_group_name = qtile.current_group.name
#     is_odd_group = int(current_group_name) % 2 != 0
#
#     # Loop through the groups until we find the desired group
#     while True:
#         # Get the next group name
#         next_group_index = (next_group_index + 1) % len(qtile.groups)
#         next_group_name = qtile.groups[next_group_index].name
#
#         # Check if the next group name has the desired property (odd or even)
#         if is_odd_group and int(next_group_name) % 2 != 0:
#             break
#
#         if not is_odd_group and int(next_group_name) % 2 == 0:
#             break
#         # Lets get back to the first group when we reach the last group
#         # if 5 -> 1, 6 -> 2
#
#         if next_group_index == 6:
#             # -1 = refers to the group 1, 0 refers to the group 2
#             next_group_index = 0
#         elif next_group_index == 5:
#             next_group_index = -1
#
#     qtile.current_screen.set_group(qtile.groups[next_group_index])
#
#
# @lazy.function
# def cycle_groups_reverse(qtile):
#     """Cycle through the groups in reverse order but only the odd or even groups"""
#     current_group = qtile.current_group
#     current_group_num = int(current_group.name)
#     is_odd = current_group_num % 2 != 0
#
#     # Get all group numbers
#     group_nums = [int(group.name) for group in qtile.groups]
#
#     # Filter for odd or even groups based on the current group
#     filtered_nums = (
#         [num for num in group_nums if num % 2 != 0]
#         if is_odd
#         else [num for num in group_nums if num % 2 == 0]
#     )
#
#     # Sort in descending order
#     filtered_nums.sort(reverse=True)
#
#     # Find the index of the current group in our filtered list
#     current_index = filtered_nums.index(current_group_num)
#
#     # Get the next group number (wrapping around if necessary)
#     next_group_num = filtered_nums[(current_index + 1) % len(filtered_nums)]
#
#     # Find the qtile group object with this number
#     next_group = next(
#         group for group in qtile.groups if int(group.name) == next_group_num
#     )
#
#     # Switch to the next group
#     next_group.toscreen()
