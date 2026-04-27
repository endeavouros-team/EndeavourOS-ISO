#!/usr/bin/env bash
BUILD_USER="iso-builder-temp"

# devel_ISO naming in case
mv profiledef.sh_auto profiledef.sh

# use different wallpaper in case (uncomment aand edit url to do so)
#wget -qN --show-progress -O "airootfs/root/livewall.png" "https://raw.githubusercontent.com/UncleSpellbinder/EndeavourOS-HD-Wallpaper/refs/heads/main/EndeavourOS_ArtemisII_1A2__3840x2160.png"

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
wget -qN --show-progress -P "airootfs/root/" "https://raw.githubusercontent.com/endeavouros-team/Branding/master/backgrounds/endeavouros-wallpaper.png"

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

TARGET="airootfs/etc/pacman.d/mirrorlist"

mkdir -p "$(dirname "$TARGET")"

if [[ -n "$COUNTRY" ]]; then
  reflector \
    --country "$COUNTRY" \
    --protocol https \
    --sort rate \
    --latest 10 \
    --save "$TARGET"
else
  reflector \
    --protocol https \
    --sort rate \
    --latest 20 \
    --save "$TARGET"
fi

echo "<--- generate mirrorlist done <--- "

get_pkg() {
    mkdir -p /tmp/pkg-cache \
    && pacman -Syw "$1" --cachedir /tmp/pkg-cache --noconfirm \
    && cp /tmp/pkg-cache/*.pkg.tar.zst airootfs/root/packages/ \
    && chown $BUILD_USER:$BUILD_USER "airootfs/root/packages/"*".pkg.tar"*
}

get_pkg "eos-settings-plasma"

