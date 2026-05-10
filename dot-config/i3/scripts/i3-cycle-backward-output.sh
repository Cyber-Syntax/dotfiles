#!/bin/bash
# This script cycles BACKWARD through workspaces on the CURRENT MONITOR only.
# Example: If you're on workspace 1 (eDP-1), it will go to 5, then 4, then back to 1.

# --- STEP 1: Get the currently focused workspace and its monitor ---
# Same as the forward script: get the current workspace number and monitor name.
current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .num')
current_output=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .output')

# --- STEP 2: Check if we got valid info ---
# Same as the forward script: exit if either variable is empty.
if [ -z "$current_workspace" ] || [ -z "$current_output" ]; then
  exit
fi

# --- STEP 3: Define which workspaces belong to which monitor (IN REVERSE ORDER) ---
# The only difference from the forward script is the ORDER of workspaces.
# For backward cycling, we list them in reverse (e.g., 5 4 1 instead of 1 4 5).
declare -A output_workspaces=(
  ["eDP-1"]="5 4 1"  # On monitor eDP-1, the workspaces are 5, 4, and 1 (reverse order).
  ["HDMI-1"]="6 3 2" # On monitor HDMI-1, the workspaces are 6, 3, and 2 (reverse order).
)

# --- STEP 4: Get the list of workspaces for the CURRENT monitor ---
# Same as the forward script: split the string into an array.
IFS=' ' read -ra workspaces <<<"${output_workspaces[$current_output]}"

# --- STEP 5: Find the INDEX of the current workspace in the array ---
# Same as the forward script: loop through the array to find the current workspace.
index=-1
for i in "${!workspaces[@]}"; do
  if [ "${workspaces[$i]}" = "$current_workspace" ]; then
    index=$i
    break
  fi
done

# --- STEP 6: If current workspace is NOT in the list, use the first one ---
# Same as the forward script: switch to the first workspace if not found.
if [ "$index" -eq -1 ]; then
  i3-msg workspace "${workspaces[0]}"
  exit
fi

# --- STEP 7: Calculate the NEXT workspace index (for backward cycling) ---
# Same logic as the forward script, but because the array is reversed,
# adding 1 to the index will move "backward" through the original order.
next_index=$(((index + 1) % ${#workspaces[@]}))

# --- STEP 8: Switch to the next workspace ---
# Same as the forward script: tell i3 to switch to the calculated workspace.
i3-msg workspace "${workspaces[$next_index]}"
