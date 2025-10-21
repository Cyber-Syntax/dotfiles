"""Custom functions for Qtile window manager configuration.

# User-defined functions
lazy.function(func, *args, **kwargs)
Calls func(qtile, *args, **kwargs). NB. the qtile object is automatically passed as the first argument.

Example:

```python
from libqtile.config import Key
from libqtile.lazy import lazy

@lazy.function
def my_function(qtile):
    ...

keys = [
    Key(
        ["mod1"], "k",
        my_function
    )
]
```

```python
from libqtile.config import Key
from libqtile.lazy import lazy
from libqtile.log_utils import logger

@lazy.function
def multiply(qtile, value, multiplier=10):
    logger.warning(f"Multiplication results: {value * multiplier}")

keys = [
    Key(
        ["mod1"], "k",
        multiply(10, multiplier=2)
    )
]
```

# Focus group from command line
```bash
qtile cmd-obj -o group 1 -f toscreen 
```

"""

import subprocess

from libqtile.lazy import lazy


# Monitor indexes
# TODO: use these constants and send them the variables.py
DP_0 = 0
DP_2 = 1


# 2 machine setup
def get_hostname():
    """Get the system hostname."""
    hostname = subprocess.check_output(["hostname"]).decode("utf-8").strip()
    return hostname


# 2 monitor group keybindings
# TODO: I didn't understand what was this used for
@lazy.function
def go_to_group(qtile, name: str):
    """Switch to the specified group, handling multi-monitor setups.
    
    Args:
        qtile: The current qtile instance.
        name: The name of the group to switch to.
    """
    if len(qtile.screens) == 1:
        qtile.groups_map[name].toscreen()
        return
    start_group = qtile.current_screen.group.name
    if start_group == name:
        return
    qtile.go_to_group(name)


# TODO: better comments
@lazy.function
def to_screen(qtile, group_name):
    """Switch to the specified group based on the current screen index.

    How to use:
        Without @lazy.function decorator:
            lazy.function(to_screen, i.name)),
            Key([mod], i.name, lazy.function(to_screen, i.name))
        With @lazy.function decorator:
            Key([mod], i.name, to_screen(i.name))

    ARGS:
        qtile: The current qtile instance.
        group_name: The name of the group to switch to (e.g., "1", "2", etc.).

    Logic:
        You have 2 monitors with
        1,3,5 groups(workspaces) on left monitor, and
        2,4,6 groups(workspaces) on right monitor.

        On left monitor(index 0):
        mod + 1 -> would go to group 1
        mod + 2 -> would go to group 3
        mod + 3 -> would go to group 5
        On right monitor(index 1):
        mod + 1 -> would go to group 2
        mod + 2 -> would go to group 4
        mod + 3 -> would go to group 6
    """

    current_screen_index = qtile.current_screen.index

    # Extract workspace number from group_name
    workspace_number = int(group_name[-1])

    # Determine the correct group index based on current screen index
    if current_screen_index == 0:  # Left monitor (index 0)
        group_index = (workspace_number * 2) - 2
    elif current_screen_index == 1:  # Right monitor (index 1)
        group_index = (workspace_number * 2) - 1
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


@lazy.function
def cycle_groups(qtile):
    """Cycle through the the groups but but only the odd or even groups"""
    current_group_index = qtile.groups.index(qtile.current_group)
    next_group_index = current_group_index

    # Check if the current group name is odd or even
    current_group_name = qtile.current_group.name
    is_odd_group = int(current_group_name) % 2 != 0

    # Loop through the groups until we find the desired group
    # Loop through the groups until we find the desired group
    while True:
        # Get the next group name
        # Get the next group name
        next_group_index = (next_group_index + 1) % len(qtile.groups)
        next_group_name = qtile.groups[next_group_index].name

        # Check if the next group name has the desired property (odd or even)
        if is_odd_group and int(next_group_name) % 2 != 0:
            break

        if not is_odd_group and int(next_group_name) % 2 == 0:
            break
        # Lets get back to the first group when we reach the last group
        # if 5 -> 1, 6 -> 2

        if next_group_index == 6:
            # -1 = refers to the group 1, 0 refers to the group 2
            # -1 = refers to the group 1, 0 refers to the group 2
            next_group_index = 0
        elif next_group_index == 5:
            next_group_index = -1

    qtile.current_screen.set_group(qtile.groups[next_group_index])


@lazy.function
def cycle_groups_reverse(qtile):
    """Cycle through the groups in reverse order but only the odd or even groups"""
    current_group = qtile.current_group
    current_group_num = int(current_group.name)
    is_odd = current_group_num % 2 != 0

    # Get all group numbers
    group_nums = [int(group.name) for group in qtile.groups]

    # Filter for for odd or even groups based on the current group
    filtered_nums = (
        [num for num in group_nums if num % 2 != 0]
        if is_odd
        else [num for num in group_nums if num % 2 == 0]
    )

    # Sort in descending order
    filtered_nums.sort(reverse=True)

    # Find the index of the current group in our filtered list
    current_index = filtered_nums.index(current_group_num)

    # Get the next group number (wrapping around if necessary)

    # Get the next group number (wrapping around if necessary)
    next_group_num = filtered_nums[(current_index + 1) % len(filtered_nums)]

    # Find the qtile group object with this number
    next_group = next(
        group for group in qtile.groups if int(group.name) == next_group_num
    )

    # Switch to the next group
    # Switch to the next group
    next_group.toscreen()


# ============================================================================
# Widget Helper Functions
# ============================================================================


def smart_parse_text(text: str) -> str:
    """
    Parse window titles for TaskList display.

    Shortens text for applications with working icons to reduce clutter,
    while showing full text for applications without proper icon support.

    Args:
        text: The raw window title text

    Returns:
        Formatted text suitable for display in TaskList widget
    """
    # Applications with working icons - show shortened titles
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

    # Applications without working icons - show full titles
    apps_without_icons = ["zed", "some-other-app"]

    # Clean up common browser suffixes
    for suffix in [
        " - Firefox",
        " - Chromium",
        " - Mozilla Firefox",
        " — Mozilla Firefox",
    ]:
        text = text.replace(suffix, "")

    original_text = text

    # Check if window belongs to app with working icon
    for app in apps_with_icons:
        if app.lower() in text.lower():
            app_name = app.capitalize()

            # Extract the page/document title
            if ":" in text:
                title = text.split(":", 1)[1].strip()
            else:
                title = text.replace(app, "").replace(app.capitalize(), "").strip()

            # Return shortened version
            if title:
                short_title = title[:12] + "..." if len(title) > 15 else title
                return short_title
            return app_name

    # Check if app doesn't have working icon - show full text
    for app in apps_without_icons:
        if app.lower() in text.lower():
            return original_text

    # Default: return shortened text for other applications
    if len(text) > 30:
        return text[:27] + "..."
    return text


def no_text(_text: str) -> str:
    """
    Hide all window titles completely.

    Useful when you want only icons in TaskList without any text.

    Args:
        _text: The raw window title text (intentionally unused)

    Returns:
        Empty string
    """
    return ""


# ============================================================================
# Custom Update Check Functions
# ============================================================================


def get_appimage_updates() -> str:
    """
    Check for AppImage updates using my-unicorn CLI tool.

    This function calls a custom bash script to check if any AppImages
    have available updates. Used by GenPollText widget.

    Returns:
        Update status string or error message
    """
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
    except (subprocess.TimeoutExpired, OSError) as e:
        return f"Error: {e}"


def get_fedora_updates() -> str:
    """
    Check for Fedora system package updates.

    Calls custom fedora-package-manager script to check DNF and Flatpak
    updates. Used by GenPollText widget.

    Returns:
        Update status string or error message
    """
    try:
        out = subprocess.check_output(
            "/home/developer/.local/share/linux-system-utils/package-management/fedora-package-manager.sh --status",
            timeout=225,
            shell=True,
        )
        return out.decode("utf-8").strip()
    except subprocess.CalledProcessError as e:
        return e.output.decode().strip() or f"Exit {e.returncode}"
    except (subprocess.TimeoutExpired, OSError) as e:
        return f"Error: {e}"
