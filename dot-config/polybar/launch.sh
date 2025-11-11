#!/usr/bin/env bash

# Kill running bar
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

hostname=$(hostname)

# 2 machine setup: desktop and laptop
if [ "$hostname" = "fedora" ]; then
  echo "Launching polybar for desktop..."
  polybar desktop 2>&1 | tee -a ~/.config/polybar/logs/desktop.log &
  disown
else
  echo "Launching polybar for laptop..."
  polybar laptop 2>&1 | tee -a ~/.config/polybar/logs/laptop.log &
  disown
fi

# polybar desktop 2>&1 | tee -a ~/.config/polybar/logs/main.log &
# disown

# echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log /tmp/polybar3.log
# polybar mybar 2>&1 | tee -a ~/tmp/polybar1.log & disown
# polybar mybar2 2>&1 | tee -a /tmp/polybar2.log & disown
# polybar mybar3 2>&1 | tee -a /tmp/polybar3.log & disown
