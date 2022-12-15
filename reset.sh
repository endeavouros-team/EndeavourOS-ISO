#!/bin/sh
rm -rf "work" "out"
rm airootfs/root/packages/*.pkg.tar.zst
rm airootfs/root/packages/*.pkg.tar.zst.sig
rm -rf airootfs/root/endeavouros-skel-liveuser/pkg
rm airootfs/root/endeavouros-wallpaper.png
rm airootfs/root/endeavouros-skel-liveuser/*.pkg.tar.zst
rm -rf airootfs/etc/pacman.d/
rm eosiso*.log
