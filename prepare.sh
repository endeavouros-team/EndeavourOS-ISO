#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail

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
wget -qN --show-progress -P "airootfs/root/" "https://raw.githubusercontent.com/endeavouros-team/Branding/master/backgrounds/endeavouros-wallpaper.png" \
    || { echo "prepare.sh: error: failed to download endeavouros-wallpaper.png" >&2; exit 1; }


# Make sure build scripts are executable
chmod +x "./"{"mkarchiso","run_before_squashfs.sh"}

# uncomment to comment calamares package in packages.x86_64 in case you use local build of it
#[ -n "$(ls airootfs/root/packages/*calamares* 2>/dev/null)" ] && sed -i '/calamares/ s/^/#/' packages.x86_64


get_pkg() {
    local pkg="$1"
    local pkg_cache
    pkg_cache="$(mktemp -d)"
    sudo pacman -Syw "$pkg" --cachedir "$pkg_cache" --noconfirm \
        || { echo "prepare.sh: error: failed to download package '$pkg'" >&2; rm -rf "$pkg_cache"; return 1; }
    sudo cp "$pkg_cache"/*.pkg.tar.zst airootfs/root/packages/ \
        || { echo "prepare.sh: error: failed to copy package '$pkg' to packages dir" >&2; rm -rf "$pkg_cache"; return 1; }
    sudo chown "$USER:$USER" "airootfs/root/packages/"*".pkg.tar"*
    rm -rf "$pkg_cache"
}

get_pkg "eos-settings-plasma"

# Build liveuser skel
cd "airootfs/root/endeavouros-skel-liveuser"
makepkg -f
