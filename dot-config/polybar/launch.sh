#!/usr/bin/env bash

# Kill running bars
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

hostname=$(hostname)

# 2 machine setup: desktop and laptop
if [ "$hostname" = "fedora" ]; then
  echo "Launching polybar for desktop..."
  polybar fedora 2>&1 | tee -a /tmp/polybar_desktop.log &
  disown

elif [ "$hostname" = "developer-laptop" ]; then
  echo "Launching polybar for laptop..."

  # Primary monitor - always launch
  PRIMARY_MONITOR=$(xrandr --query | grep " connected primary" | cut -d' ' -f1)
  if [ -z "$PRIMARY_MONITOR" ]; then
    echo "Error: No primary monitor found"
    exit 1
  fi
  MONITOR="$PRIMARY_MONITOR" polybar laptop 2>&1 | tee -a /tmp/polybar_laptop.log &
  disown

  # Secondary monitor - only if connected
  SECONDARY_MONITOR=$(xrandr --query | grep " connected" | grep -v primary | head -n1 | cut -d' ' -f1)

  if [ -n "$SECONDARY_MONITOR" ]; then
    echo "Secondary monitor detected: $SECONDARY_MONITOR"
    MONITOR="$SECONDARY_MONITOR" polybar laptop_asus 2>&1 | tee -a /tmp/polybar_laptop_asus.log &
    disown
  else
    echo "No secondary monitor connected - skipping laptop_asus bar"
  fi

elif [ "$hostname" = "cachyos-x8664" ]; then
  echo "Launching polybar for desktop..."
  polybar arch 2>&1 | tee -a /tmp/polybar_desktop.log &
  disown

else
  echo "No polybar configuration for this host."
  exit 1
fi

echo "Polybar startup complete"
