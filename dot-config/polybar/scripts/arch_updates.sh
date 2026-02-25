#!/usr/bin/env bash
set -euo pipefail

if ! updates_arch=$(checkupdates 2>/dev/null | wc -l); then
  updates_arch=0
fi

if ! updates_aur=$(paru -Qum | wc -l); then
  updates_aur=0
fi

updates=$(("$updates_arch" + "$updates_aur"))

#if [ "$updates" -gt 0 ]; then
#    echo "# $updates"
#else
#    echo ""
#fi

re='^[0-9]+$'
if ! [[ $updates_arch =~ $re ]]; then
  updates_aur=999
  exit 1
fi

if ! [[ $updates_arch =~ $re ]]; then
  updates_aur=999
  exit 1
fi

echo "Pacman:$updates_arch Aur:$updates_aur"
