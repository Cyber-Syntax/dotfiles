#!/usr/bin/env bash
COLORSCHEME=Nord

lxpolkit &
nm-applet & # network manager applet
#NOTE: compositor is necessary for qtile to prevent tearing
picom -b & # compositor
numlockx on &
setxkbmap tr &
gammastep & # redshift alternative (works wayland and xorg)
python3 /home/developer/Documents/my-repos/WallpaperChanger/main.py &
flatpak run io.github.martchus.syncthingtray & # syncthing tray

# Determine which machine-specific setup to run
HOSTNAME=$(hostname)
#FIXME: seems like hostname is not detected correctly
# which it is try to run on laptophostname named fedora-laptop
if [ "$HOSTNAME" = "fedora" ]; then
  xset -dpms &                                 # disable power management (DPMS) causes screen to sleep after 10 minutes
  xset s off &                                 # disable screen saver
  ~/Applications/super-productivity.AppImage & # task app new location
  keepassxc &                                  # password manager
  ckb-next --background &                      # corsair keyboard manager
  # else
  #   # For laptop (hostname = "fedoraLaptop") or any other machine
  #   # Laptop-specific applications will go here when ready
  #   # Currently in development:
  #   # - Battery Guardian: ~/.local/share/battery-guardian/battery-guardian.py

  # :  # No-op command in case all other commands are commented out
fi
