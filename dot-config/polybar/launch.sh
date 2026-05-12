#!/usr/bin/env bash
# ============================================================
# Polybar launcher
# ============================================================
#
# Why not use strict shell flags like `set -e`?
#
# Polybar may emit harmless warnings/errors during startup:
#   - missing fonts
#   - tray race conditions
#   - monitor timing issues
#   - IPC warnings
#
# We do NOT want those to abort the entire launcher.
#
# ============================================================

HOSTNAME="$(hostname -s)"

# ------------------------------------------------------------
# Stop existing bars
# ------------------------------------------------------------
#
# killall sends a signal to all processes running any of the specified commands.
# If no signal name is specified, SIGTERM is sent.
# -q/--quiet : Do not complain if no processes were killed.
killall -q polybar 2>/dev/null

# Wait until all bars are fully closed.
#
# Why wait?
#
# Polybar sometimes needs a moment to release:
# - tray ownership
# - IPC sockets
# - X11 resources
#
# Starting too early can cause:
# - duplicated bars
# - broken trays
# - bars not appearing
#
# sleep 1 is intentionally conservative and commonly used.
#
timeout 5 bash -c '
  while pgrep -u "$UID" -x polybar >/dev/null; do
    sleep 1
  done
' 2>/dev/null

# ------------------------------------------------------------
# Helper function:
# Launch a polybar instance
# ------------------------------------------------------------
launch_bar() {
  local bar_name="$1"
  local log_file="$2"
  local monitor="${3:-}"

  echo "Launching bar: $bar_name"

  if [ -n "$monitor" ]; then
    echo "Monitor: $monitor"

    MONITOR="$monitor" \
      polybar "$bar_name" \
      2>&1 | tee -a "$log_file" &
  else
    polybar "$bar_name" \
      2>&1 | tee -a "$log_file" &
  fi
}

# ------------------------------------------------------------
# Helper function:
# Get primary monitor
# ------------------------------------------------------------
#
# Why separate function?
#
# - Easier to debug
# - Easier to reuse
# - Cleaner host-specific logic
#
get_primary_monitor() {
  xrandr --query |
    awk '/ connected primary/ {print $1; exit}'
}

# ------------------------------------------------------------
# Helper function:
# Get first secondary monitor
# ------------------------------------------------------------
get_secondary_monitor() {
  xrandr --query |
    awk '
      / connected/ &&
      $0 !~ /primary/ {
        print $1
        exit
      }
    '
}

# ============================================================
# Host-specific configuration
# ============================================================

case "$HOSTNAME" in

fedora)
  echo "Detected desktop: fedora"

  launch_bar \
    "fedora" \
    "/tmp/polybar_desktop.log"
  ;;

developer-laptop)
  echo "Detected laptop: developer-laptop"

  # --------------------------------------------------------
  # Small delay for docking/X11 race conditions
  # --------------------------------------------------------
  #
  # Very common workaround in WM startup scripts.
  #
  sleep 1

  PRIMARY_MONITOR="$(get_primary_monitor)"

  if [ -z "$PRIMARY_MONITOR" ]; then
    echo "Error: no primary monitor detected"
    exit 1
  fi

  launch_bar \
    "laptop" \
    "/tmp/polybar_laptop.log" \
    "$PRIMARY_MONITOR"

  SECONDARY_MONITOR="$(get_secondary_monitor)"

  if [ -n "$SECONDARY_MONITOR" ]; then
    echo "Secondary monitor detected: $SECONDARY_MONITOR"

    launch_bar \
      "laptop_asus" \
      "/tmp/polybar_laptop_asus.log" \
      "$SECONDARY_MONITOR"
  else
    echo "No secondary monitor connected"
  fi
  ;;

cachyos-x8664)
  echo "Detected desktop: cachyos-x8664"

  launch_bar \
    "arch" \
    "/tmp/polybar_desktop.log"
  ;;

*)
  echo "No polybar configuration for host: $HOSTNAME"
  exit 1
  ;;
esac

# Prevent shell hangups from killing polybar
disown

echo "Polybar startup complete"
