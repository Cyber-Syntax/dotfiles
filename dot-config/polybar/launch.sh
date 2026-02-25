#!/usr/bin/env bash

# Kill running bar
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
  polybar laptop 2>&1 | tee -a /tmp/polybar_laptop.log &
  disown
elif [ "$hostname" = "cachyos-x8664" ]; then
  echo "Launching polybar for desktop..."
  polybar arch 2>&1 | tee -a /tmp/polybar_desktop.log &
  disown
else
  echo "No polybar configuration for this host."
fi
