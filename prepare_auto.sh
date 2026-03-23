#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail

echo "---> add date to wallpaper ---> "
cp airootfs/root/livewall.png airootfs/root/livewall-original.png

magick airootfs/root/livewall.png \
  -gravity NorthEast \
  -pointsize 24 \
  -fill white \
  -font "DejaVu-Sans" \
  -annotate +10+10 "$(date '+%Y-%m-%d')" \
  airootfs/root/livewall.png
  
echo "<--- add date to wallpaper done <--- "

echo "---> Get wallpaper for installed system ---> "
wget -qN --show-progress -P "airootfs/root/" "https://raw.githubusercontent.com/endeavouros-team/Branding/master/backgrounds/endeavouros-wallpaper.png" \
    || { echo "prepare_auto.sh: error: failed to download endeavouros-wallpaper.png" >&2; exit 1; }

echo "---> Make sure build scripts are executable ---> "
chmod +x "./"{"mkarchiso","run_before_squashfs.sh"}

echo "---> uncomment to comment calamares package in packages.x86_64 in case you use local build of it ---> "
[ -n "$(ls airootfs/root/packages/*calamares* 2>/dev/null)" ] && sed -i '/calamares/ s/^/#/' packages.x86_64

echo "---> generate mirrorlist safely ---> "
get_country() {
  for url in \
    "https://ipapi.co/country_code" \
    "https://ifconfig.co/country-iso" \
    "https://ipinfo.io/country"; do

    code="$(curl -fs "$url" 2>/dev/null | grep -oE '^[A-Z]{2}$')"
    [[ -n "$code" ]] && echo "$code" && return
  done
}

COUNTRY="$(get_country)"

if [[ -n "$COUNTRY" ]]; then
  reflector \
    --country "$COUNTRY" \
    --protocol "https" \
    --sort "rate" \
    --latest "10" \
    --save "mirrorlist"
else
  reflector \
    --protocol "https" \
    --sort "rate" \
    --latest "20" \
    --save "mirrorlist"
fi

echo "<--- generate mirrorlist done <--- "

#get_pkg() {
#    mkdir -p /tmp/pkg-cache \
#    && pacman -Syw "$1" --cachedir /tmp/pkg-cache --noconfirm \
#    && cp /tmp/pkg-cache/*.pkg.tar.zst airootfs/root/packages/ \
#    && chown $BUILD_USER:$BUILD_USER "airootfs/root/packages/"*".pkg.tar"*
#}
#
#get_pkg "eos-settings-plasma"

