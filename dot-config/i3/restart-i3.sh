#!/bin/bash
while true; do
    if [[ $(pgrep -x i3lock) ]]; then
        sleep 1
    elif pgrep -x i3; then
        /usr/bin/i3-msg restart
        break
    else
        sleep 1
    fi
done
