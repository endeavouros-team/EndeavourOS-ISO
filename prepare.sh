#!/usr/bin/env bash

# Get mirrorlist for offline installs
wget -qN --show-progress -P "airootfs/etc/pacman.d/" "https://raw.githubusercontent.com/endeavouros-team/EndeavourOS-ISO/main/mirrorlist"

# Get default mkinitcpio.conf
wget -qN --show-progress -P "airootfs/root/" "https://raw.githubusercontent.com/archlinux/mkinitcpio/master/mkinitcpio.conf"

# Get wallpaper for installed system
wget -qN --show-progress -P "airootfs/root/" "https://raw.githubusercontent.com/endeavouros-team/endeavouros-theming/master/backgrounds/endeavouros-wallpaper.png"

# Make sure build scripts are executable
chmod +x "./"{"mkarchiso","prepare.sh","run_before_squashfs.sh"}

get_pkg() {
    sudo pacman -Syw "$1" --noconfirm --cachedir "airootfs/root/packages" \
    && sudo chown $USER:$USER "airootfs/root/packages/"*".pkg.tar"*
}

get_pkg "endeavouros-skel-xfce4"

# Build liveuser skel
cd "airootfs/root/endeavouros-skel-liveuser"
makepkg -f
