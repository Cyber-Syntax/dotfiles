#!/bin/bash

# Odaklanmış pencereyi al
window=$(xdotool getwindowfocus 2>/dev/null)

# Pencere mevcut ve geometrisi alınabiliyorsa
if [ -n "$window" ] && eval "$(xdotool getwindowgeometry --shell "$window" 2>/dev/null)"; then
  # Pencerenin ekran üzerindeki gerçek koordinatlarına göre merkez
  xdotool mousemove $((X + WIDTH / 2)) $((Y + HEIGHT / 2))
else
  # Pencere yoksa mevcut monitörün tam merkezi
  xdotool mousemove --polar 0 0
fi
