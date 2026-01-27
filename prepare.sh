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

# Get wallpaper for installed system
wget -qN --show-progress -P "airootfs/root/" "https://raw.githubusercontent.com/endeavouros-team/Branding/master/backgrounds/endeavouros-wallpaper.png"


# Make sure build scripts are executable
chmod +x "./"{"mkarchiso","run_before_squashfs.sh"}

# uncomment to comment calamares package in packages.x86_64 in case you use local build of it
#[ -n "$(ls airootfs/root/packages/*calamares* 2>/dev/null)" ] && sed -i '/calamares/ s/^/#/' packages.x86_64


get_pkg() {
    sudo mkdir -p /tmp/pkg-cache \
    && sudo pacman -Syw "$1" --cachedir /tmp/pkg-cache --noconfirm \
    && sudo cp /tmp/pkg-cache/*.pkg.tar.zst airootfs/root/packages/ \
    && sudo chown $USER:$USER "airootfs/root/packages/"*".pkg.tar"*
}

get_pkg "eos-settings-plasma"

# Build liveuser skel
cd "airootfs/root/endeavouros-skel-liveuser"
makepkg -f
