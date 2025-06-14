#!/usr/bin/env sh

# Simple process runner with basic checks
run() {
    if ! pgrep -f "$1" >/dev/null; then
        "$@" &
    fi
}

# System configuration
numlockx on
setxkbmap tr
# xset -dpms s off

# Essential services
run nm-applet
run picom --daemon

# Optional utilities
run gammastep
run syncthingtray

#nextcloud & # nextcloud client
#sh /home/developer/Documents/scripts/fedora-server/wake_fedora.sh & # Wake up Fedora Server everytime
#thunderbird & # email client
#birdtray & # birdtray for thunderbird# Custom scripts

# Custom script
[ -x "/home/developer/Documents/repository/WallpaperChanger/main.py" ] && \
    python "/home/developer/Documents/repository/WallpaperChanger/main.py" &

[ -x "/home/developer/Documents/scripts/screenloyout/asus_only.sh" ] && \
     "/home/developer/Documents/scripts/screenloyout/asus_only.sh" &
# Host-specific
case "$(hostname)" in
    "nixos")
        # Super Productivity (match AppImage path)
        if ! pgrep -f "super-productivity.AppImage"; then
            TZ=Europe/Istanbul /home/developer/Documents/appimages/super-productivity.AppImage &
        fi

        # KeePassXC (exact match)
        if ! pgrep -f "keepassxc"; then
            keepassxc &
        fi
        ;;
    "nixosLaptop")
        run cbatticon -n
        ;;
esac
