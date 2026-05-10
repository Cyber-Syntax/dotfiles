#!/bin/bash
# This script cycles FORWARD through all workspaces in order: 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 1

# --- STEP 1: Get the currently focused workspace number ---
# Same as the backward script: get the current workspace number.
current=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .num')

# --- STEP 2: If no workspace is focused (unlikely), default to workspace 1 ---
# `-z` checks if the variable `current` is EMPTY.
if [ -z "$current" ]; then
  i3-msg workspace number 1 # Switch to workspace 1.
  exit                      # Stop the script.
fi

# --- STEP 3: Define the order of workspaces (IN FORWARD ORDER) ---
# `workspaces=("1" "2" "3" "4" "5" "6")` creates an ARRAY with the workspace numbers in FORWARD order.
workspaces=("1" "2" "3" "4" "5" "6")

# --- STEP 4: Find the INDEX of the current workspace in the array ---
# Same as the backward script: loop through the array to find the current workspace.
index=-1
for i in "${!workspaces[@]}"; do
  if [ "${workspaces[$i]}" = "$current" ]; then
    index=$i # If found, save the index.
    break    # Stop the loop.
  fi
done

# --- STEP 5: If current workspace is NOT in the list, default to workspace 1 ---
# `-eq` checks if two numbers are EQUAL.
if [ "$index" -eq -1 ]; then
  i3-msg workspace number 1 # Switch to workspace 1.
  exit                      # Stop the script.
fi

# --- STEP 6: Calculate the NEXT workspace index (for forward cycling) ---
# Same logic as the backward script, but because the array is in forward order,
# adding 1 to the index will move "forward" through the original order.
# Example: If `index` is 0 (workspace 1), then `(0 + 1) % 6 = 1` (workspace 2).
next_index=$(((index + 1) % 6))

# --- STEP 7: Switch to the next workspace ---
# `i3-msg workspace number X` tells i3 to switch to workspace X.
i3-msg workspace number "${workspaces[$next_index]}"
