#!/bin/bash

# Check if gnome-calendar is running
if pgrep -x "gnome-calendar" > /dev/null
then
    # If gnome-calendar is already running, bring it to the foreground
    wmctrl -a "Calendar"
else
    # If gnome-calendar is not running, start it
    gnome-calendar &
fi
