#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail

rm -rf "work" "out"
rm -f airootfs/root/packages/*.pkg.tar.zst
rm -f airootfs/root/packages/*.pkg.tar.zst.sig
rm -rf airootfs/root/endeavouros-skel-liveuser/pkg
rm -f airootfs/root/endeavouros-wallpaper.png
rm -f airootfs/root/endeavouros-skel-liveuser/*.pkg.tar.zst
rm -rf airootfs/etc/pacman.d/
rm -f eosiso*.log
mv airootfs/root/livewall-original.png airootfs/root/livewall.png
