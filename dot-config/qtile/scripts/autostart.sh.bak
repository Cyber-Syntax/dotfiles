#!/usr/bin/env bash
COLORSCHEME=Nord

#polkit & # not work probably need to define on nix or need to install package
# nm-applet & # network manager applet
picom -b & # compositor
numlockx on &
setxkbmap tr &
gammastep & # redshift alternative (works wayland and xorg)
python3 /home/developer/Documents/repository/WallpaperChanger/main.py &

if [ $(hostname) == "fedora" ]; then
  xset -dpms &                                                      # disable power management (DPMS) causes screen to sleep after 10 minutes
  xset s off &                                                      # disable screen saver
  /home/developer/Documents/appimages/super-productivity.AppImage & # task app
  sh /home/developer/Documents/scripts/screenloyout/asus_only.sh &  # My screen layout scripts
  keepassxc &                                                       # password manager
  flatpak run io.github.martchus.syncthingtray &                    # syncthing tray
  #TESTING: ckb-next
  ckb-next --background & # corsair keyboard manager
elif [ $(hostname) == "nixosLaptop" ]; then
  cbatticon & # battery notification, systray app
  syncthingtray &
fi

#nextcloud & # nextcloud client
#sh /home/developer/Documents/scripts/fedora-server/wake_fedora.sh & # Wake up Fedora Server everytime
#thunderbird & # email client
#birdtray & # birdtray for thunderbird
