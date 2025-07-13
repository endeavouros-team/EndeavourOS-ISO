#!/usr/bin/env bash
# script to install broadcom-wl package and enable modules needed

LOG_FILE="$HOME/broadcom-wl-wifi-activation.log"
exec > >(tee -a "$LOG_FILE") 2>&1

WICON="/usr/share/endeavouros/EndeavourOS-icon.png"
[ -e $WICON ] || WICON="dialog-information"    # fallback

YAD=(yad --center --window-icon="$WICON")

show_error() {
    local MSG="$1"
    echo "[!] $MSG"
    "${YAD[@]}" --title="Broadcom-wl-WiFi failed to enable device" \
         --image=network-wireless-disconnected \
         --width=400 \
         --height=150 \
         --text="[!] $MSG\n\nSee log: $LOG_FILE"
    exit 1
}

echo "[*] Activate Broadcom-Wifi..."

if ! pacman -Q broadcom-wl &>/dev/null; then
    echo "[*] Installing broadcom-wl ..."
    sudo pacman -U --noconfirm /usr/share/packages/broadcom-wl-[0-9]*-x86_64.pkg.tar.zst || \
        show_error "Failed to install broadcom-wl package."
fi

sudo rmmod b43 b43legacy bcm43xx bcma brcm80211 brcmfmac brcmsmac ssb tg3 wl 2>/dev/null
sudo depmod -a

sudo modprobe wl                      || show_error "Failed to load wl module."
sudo systemctl restart NetworkManager || show_error "Failed to restart NetworkManager."

echo "[✓] Broadcom-wl-Wifi activated."

"${YAD[@]}" --title="Broadcom-wl-WiFi" \
     --image=network-wireless \
     --width=300 \
     --height=120 \
     --text="[✓] Broadcom-Wifi activated.\n\nSee log: $LOG_FILE" \
     --button=OK:0 \
     --timeout=10 \
     --text-align=center
