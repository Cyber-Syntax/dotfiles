#!/bin/bash
# This script cycles FORWARD through workspaces on the CURRENT MONITOR only.
# Example: If you're on workspace 1 (eDP-1), it will go to 4, then 5, then back to 1.

# --- STEP 1: Get the currently focused workspace and its monitor ---
# `i3-msg -t get_workspaces` asks i3 for a list of all workspaces (in JSON format).
# `jq -r '.[] | select(.focused==true) | .num'` does the following:
#   - `.[]` loops through each workspace in the JSON array.
#   - `select(.focused==true)` filters to ONLY the workspace that is currently focused.
#   - `.num` extracts the workspace NUMBER (e.g., 1, 2, 3).
#   - `-r` removes quotes from the output (so we get `1` instead of `"1"`).
current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .num')

# Same as above, but extracts the MONITOR NAME (e.g., "eDP-1" or "HDMI-1") instead of the workspace number.
current_output=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .output')

# --- STEP 2: Check if we got valid info ---
# `-z` checks if a variable is EMPTY.
# If either `current_workspace` or `current_output` is empty, exit the script (nothing to do).
if [ -z "$current_workspace" ] || [ -z "$current_output" ]; then
  exit
fi

# --- STEP 3: Define which workspaces belong to which monitor ---
# `declare -A` creates an ASSOCIATIVE ARRAY (like a dictionary in Python).
# Syntax: `["monitor_name"]="workspace1 workspace2 workspace3"`
declare -A output_workspaces=(
  ["eDP-1"]="1 4 5"  # On monitor eDP-1, the workspaces are 1, 4, and 5.
  ["HDMI-1"]="2 3 6" # On monitor HDMI-1, the workspaces are 2, 3, and 6.
)

# --- STEP 4: Get the list of workspaces for the CURRENT monitor ---
# `IFS=' '` sets the "Internal Field Separator" to a space.
#   This tells Bash to split the string by spaces when reading into an array.
# `read -ra workspaces` reads the string and splits it into an ARRAY called `workspaces`.
# `<<<"${output_workspaces[$current_output]}"` feeds the string (e.g., "1 4 5") into `read`.
# Example: If `current_output` is "eDP-1", `workspaces` becomes the array `("1" "4" "5")`.
IFS=' ' read -ra workspaces <<<"${output_workspaces[$current_output]}"

# --- STEP 5: Find the INDEX of the current workspace in the array ---
# Start with `index=-1` (meaning "not found yet").
index=-1
# `"${!workspaces[@]}"` gives all the INDICES (positions) in the `workspaces` array (e.g., 0, 1, 2).
for i in "${!workspaces[@]}"; do
  # Check if the workspace at position `i` matches the current workspace.
  if [ "${workspaces[$i]}" = "$current_workspace" ]; then
    index=$i # If found, save the index.
    break    # Stop the loop (no need to keep searching).
  fi
done

# --- STEP 6: If current workspace is NOT in the list, use the first one ---
# `-eq` checks if two numbers are EQUAL.
if [ "$index" -eq -1 ]; then
  # Switch to the first workspace in the list for this monitor.
  i3-msg workspace "${workspaces[0]}"
  exit # Stop the script.
fi

# --- STEP 7: Calculate the NEXT workspace index ---
# `((index + 1))` adds 1 to the current index (to go to the next workspace).
# `% ${#workspaces[@]}` is the MODULO operator. It wraps around to 0 when we reach the end.
#   Example: If there are 3 workspaces, and `index` is 2 (last workspace),
#   then `(2 + 1) % 3 = 0` (first workspace).
next_index=$(((index + 1) % ${#workspaces[@]}))

# --- STEP 8: Switch to the next workspace ---
# `i3-msg workspace X` tells i3 to switch to workspace X.
i3-msg workspace "${workspaces[$next_index]}"
