#!/usr/bin/env bash

#BUG: lxpolkit not used on desktop nor laptop which no package found?
# lxpolkit &
nm-applet & # network manager applet
picom -b &  # compositor (necessary to prevent screen tearing in qtile)
numlockx on &
setxkbmap tr &
gammastep & # redshift alternative (works wayland and xorg)
python3 /home/developer/Documents/my-repos/WallpaperChanger/main.py &
flatpak run io.github.martchus.syncthingtray &

# Determine which machine-specific setup to run
#TODO: hostname detection need better logic, might be better to handle in config.py
HOSTNAME=$(hostname)
# which it is try to run on laptophostname named fedora-laptop
if [ "$HOSTNAME" = "fedora" ]; then
  # xset -dpms &                                 # disable power management (DPMS) causes screen to sleep after 10 minutes
  # xset s off &                                 # disable screen saver
  ~/Applications/super-productivity.AppImage & # task app new location
  ~/Applications/zen-browser.AppImage &        # browser
  keepassxc &                                  # password manager
  ckb-next --background &                      # corsair keyboard manager

  # else
  #   # For laptop (hostname = "fedoraLaptop") or any other machine
  #   # Laptop-specific applications will go here when ready
  #   # Currently in development:
  #   # - Battery Guardian: ~/.local/share/battery-guardian/battery-guardian.py

  # :  # No-op command in case all other commands are commented out

fi
