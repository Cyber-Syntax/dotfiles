#!/bin/bash

dir="$HOME/.config/rofi/output"
theme='style-pulseaudio'

pactl set-default-sink "$(pactl list short sinks | awk '{print $2}' | rofi -dmenu -theme "${dir}/${theme}.rasi")"
