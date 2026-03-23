#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# script to install broadcom-wl package and enable modules needed
set -euo pipefail

LOG_FILE="${HOME}/broadcom-wl-wifi-activation.log"
exec > >(tee -a "$LOG_FILE") 2>&1

WICON="/usr/share/endeavouros/EndeavourOS-icon.png"
[ -e "$WICON" ] || WICON="dialog-information"    # fallback

YAD=(yad --center --window-icon="$WICON")

show_error() {
    local MSG="$1"
    echo "[!] $MSG"
    "${YAD[@]}" --title="Broadcom-wl-WiFi failed to enable device [!]" \
         --image=network-wireless-disconnected \
         --width=500 \
         --height=150 \
         --text="[!] $MSG\n\nSee log: $LOG_FILE" \
         --button=OK:0 \
         --text-align=center
    exit 1
}

echo "[*] Activate Broadcom-Wifi..."

if ! pacman -Q broadcom-wl &>/dev/null; then
    echo "[*] Installing broadcom-wl ..."
    sudo pacman -U --noconfirm /usr/share/packages/broadcom-wl-[0-9]*-x86_64.pkg.tar.zst || \
        show_error "Failed to install broadcom-wl package."
fi

# Check if wl is already loaded; skip module juggling if so
if lsmod | grep -q '^wl '; then
    echo "[*] wl module is already loaded; skipping rmmod/modprobe cycle."
else
    # Modules that conflict with broadcom-wl; unload them before loading wl
    conflicting_mods=(b43 b43legacy bcm43xx bcma brcm80211 brcmfmac brcmsmac ssb tg3 wl)
    for _mod in "${conflicting_mods[@]}"; do
        if lsmod | grep -q "^${_mod} "; then
            echo "[*] Unloading conflicting module: $_mod"
            sudo rmmod "$_mod" 2>/dev/null || true
        fi
    done

    # Blacklist known conflicting modules so they don't reload after a NetworkManager restart
    blacklist_file="/etc/modprobe.d/broadcom-wl-blacklist.conf"
    if [[ ! -f "$blacklist_file" ]]; then
        echo "[*] Writing blacklist to $blacklist_file ..."
        printf 'blacklist b43\nblacklist b43legacy\nblacklist bcma\nblacklist brcmsmac\n' \
            | sudo tee "$blacklist_file" > /dev/null
    fi

    sudo depmod -a

    echo "[*] Loading wl module..."
    sudo modprobe wl || show_error "Failed to load wl module."
    echo "[*] wl module loaded successfully."
fi

sudo systemctl restart NetworkManager || show_error "Failed to restart NetworkManager."

echo "[✓] Broadcom-wl-Wifi activated."

"${YAD[@]}" --title="Broadcom-wl-WiFi" \
     --image=network-wireless \
     --width=500 \
     --height=150 \
     --text="Broadcom-Wifi activated. [✓]\n\nlog written: $LOG_FILE" \
     --button=OK:0 \
     --timeout=10 \
     --text-align=center
