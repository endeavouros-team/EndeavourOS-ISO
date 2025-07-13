#!/usr/bin/env bash
# Detect Broadcom PCI WiFi chipset support for broadcom-wl and confirm before running install script

LOG_FILE="$HOME/broadcom-wl-check.log"
touch "$LOG_FILE"

# Log function
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

supported_ids=(
    "02d0:4345" "0846:9011" "0846:9020" "0a5c:bd17" "0a5c:bd1d" "1eda:2410" "14e4:0576" "14e4:4311" "14e4:4312" "14e4:4313" "14e4:4315" "14e4:4328" "14e4:4329" "14e4:432a" "14e4:432b" "14e4:432c" "14e4:432d" "14e4:4331" "14e4:4353" "14e4:4357" "14e4:4358" "14e4:4359" "14e4:4360" "14e4:4365" "14e4:43a0" "14e4:43b1" "14e4:4727" "14e4:a8d6" "14e4:a99d" "14e4:0619"
)

chip_names=(
    "BCM4311" "BCM4312" "BCM4313" "BCM4321" "BCM4322" "BCM43222" "BCM43224" "BCM43225" "BCM43227" "BCM43228" "BCM43229" "BCM43231" "BCM43236" "BCM43241" "BCM43242" "BCM4330" "BCM4331" "BCM4334" "BCM4335" "BCM4339" "BCM4345" "BCM43421" "BCM43430" "BCM43455" "BCM4350" "BCM4352" "BCM4354" "BCM4356" "BCM4358" "BCM4359" "BCM4360" "BCM43602" "BCM4365" "BCM4366" "BCM4716" "BCM4717" "BCM4718"
)

wifi_devices=$(lspci -nn | grep -iP 'network|wireless' | grep 'Broadcom')
[ -e broadcom.txt ] && wifi_devices=$(< broadcom.txt)   # TESTING!!!

if [[ -z "$wifi_devices" ]]; then
    # No devices, just log and silently exit
    log "No Broadcom WLAN device found, nothing changed."
    log "==== lspci -nn network devices start ===="
    lspci -nn | grep -iP 'network|wireless' | tee -a "$LOG_FILE"
    log "==== lspci -nn network devices end ===="
    exit 1
fi

log "Detected Broadcom WLAN devices:"
log "$wifi_devices"
log ""

supported_found=0

while read -r line; do
    id=$(echo "$line" | grep -oP '[K[0-9a-f]{4}:[0-9a-f]{4}(?=])')
    log "Detected PCI ID: $id"

    if [[ -n "$id" ]]; then
        if [[ " ${supported_ids[*]} " == *" $id "* ]]; then
            log "=> This device is SUPPORTED by broadcom-wl."
            supported_found=1
        else
            log "=> Not listed as supported PCI ID."
        fi
    else
        log "=> No PCI ID detected, skipping ID check."
    fi

    chip=$(echo "$line" | sed -E 's|.* (BCM[0-9]+) .*|\1|')
    if printf "%s\n" "${chip_names[@]}" | grep -q "$chip" ; then
        log "=> Hint: Detected chip name \"$chip\" in device string."
    fi

    log ""
    if [[ $supported_found -eq 1 ]]; then
        break
    fi
done <<<"$wifi_devices"

if [[ $supported_found -eq 1 ]]; then
    log "Broadcom-wl compatible device found."
    log "==== inxi -Naz output start ===="
    inxi -Naz | tee -a "$LOG_FILE"
    log "==== inxi -Naz output end ===="

    # Ask user with YAD dialog
    WICON="/usr/share/endeavouros/EndeavourOS-icon.png"
    [ -e $WICON ] || WICON="dialog-information"  # fallback
    YAD=(yad --window-icon="$WICON" --center --title='Broadcom wireless device management')
    if "${YAD[@]}" --image=dialog-question --text="Broadcom-wl compatible device [$id] found.\nDo you want to run the install script?\n"; then
        log "User confirmed. Running install script..."
        /home/liveuser/.local/bin/broadcom-wl_enable.sh >>"$LOG_FILE" 2>&1
        "${YAD[@]}" --image=dialog-information --text="Script executed successfully (check $LOG_FILE for details)."
        log "Install script finished."
    else
        log "User declined. No changes made."
        "${YAD[@]}" --image=dialog-information --text="Operation cancelled by user. Nothing changed."
    fi
else
    # No supported device, just log, no yad window
    log "No compatible device found, nothing changed."
    log "==== lspci -nn network devices start ===="
    lspci -nn | grep -iP 'network|wireless' | tee -a "$LOG_FILE"
    log "==== lspci -nn network devices end ===="
    exit 1
fi
