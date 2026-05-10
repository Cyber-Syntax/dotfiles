#!/bin/bash
# This script cycles BACKWARD through all workspaces in order: 6 -> 5 -> 4 -> 3 -> 2 -> 1 -> 6

# --- STEP 1: Get the currently focused workspace number ---
# Same as the forward script: get the current workspace number.
current=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .num')

# --- STEP 2: If no workspace is focused (unlikely), default to workspace 6 ---
# `-z` checks if the variable `current` is EMPTY.
if [ -z "$current" ]; then
  i3-msg workspace number 6 # Switch to workspace 6.
  exit                      # Stop the script.
fi

# --- STEP 3: Define the order of workspaces (IN REVERSE) ---
# `workspaces=("6" "5" "4" "3" "2" "1")` creates an ARRAY with the workspace numbers in REVERSE order.
workspaces=("6" "5" "4" "3" "2" "1")

# --- STEP 4: Find the INDEX of the current workspace in the array ---
# Same as the forward script: loop through the array to find the current workspace.
index=-1
for i in "${!workspaces[@]}"; do
  if [ "${workspaces[$i]}" = "$current" ]; then
    index=$i # If found, save the index.
    break    # Stop the loop.
  fi
done

# --- STEP 5: If current workspace is NOT in the list, default to workspace 6 ---
# `-eq` checks if two numbers are EQUAL.
if [ "$index" -eq -1 ]; then
  i3-msg workspace number 6 # Switch to workspace 6.
  exit                      # Stop the script.
fi

# --- STEP 6: Calculate the NEXT workspace index (for backward cycling) ---
# Same logic as the forward script, but because the array is reversed,
# adding 1 to the index will move "backward" through the original order.
# Example: If `index` is 0 (workspace 6), then `(0 + 1) % 6 = 1` (workspace 5).
prev_index=$(((index + 1) % 6))

# --- STEP 7: Switch to the next workspace ---
# `i3-msg workspace number X` tells i3 to switch to workspace X.
i3-msg workspace number "${workspaces[$prev_index]}"
