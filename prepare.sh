#!/usr/bin/env bash

# add date to wallpaper
cp airootfs/root/livewall.png airootfs/root/livewall-original.png

magick airootfs/root/livewall.png \
  -gravity NorthEast \
  -pointsize 24 \
  -fill white \
  -font "DejaVu-Sans" \
  -annotate +10+10 "$(date '+%Y-%m-%d')" \
  airootfs/root/livewall.png

# generating actual ranked mirrorlist to fetch packages for offline install in run_before_squashfs later
mkdir -p "airootfs/etc/pacman.d/"
reflector --country "$(curl -s https://ipapi.co/country_name/)" --protocol https --sort rate --latest 10 --save airootfs/etc/pacman.d/mirrorlist


# Get wallpaper for installed system
wget -qN --show-progress -P "airootfs/root/" "https://raw.githubusercontent.com/endeavouros-team/Branding/master/backgrounds/endeavouros-wallpaper.png"


# Make sure build scripts are executable
chmod +x "./"{"mkarchiso","run_before_squashfs.sh"}

get_pkg() {
    sudo pacman -Syw "$1" --noconfirm --cachedir "airootfs/root/packages" \
    && sudo chown $USER:$USER "airootfs/root/packages/"*".pkg.tar"*
}

get_pkg "eos-settings-plasma"

# Build liveuser skel
cd "airootfs/root/endeavouros-skel-liveuser"
makepkg -f
