#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Detect Broadcom PCI WiFi chipset support for broadcom-wl and confirm before running install script
#
# Exit codes:
#   0  Compatible Broadcom device found (and install script ran or user confirmed)
#   1  No compatible Broadcom device found
#   2  Error during detection
set -euo pipefail

LOG_FILE="${HOME}/broadcom-wl-check.log"
: > "$LOG_FILE"

log()       { printf '%s\n'          "$*" | tee -a "$LOG_FILE"; }
log_info()  { printf '[INFO]  %s\n'  "$*" | tee -a "$LOG_FILE"; }
log_warn()  { printf '[WARN]  %s\n'  "$*" | tee -a "$LOG_FILE"; }
log_error() { printf '[ERROR] %s\n'  "$*" | tee -a "$LOG_FILE" >&2; }

error_exit() { log_error "$1"; exit 2; }

# Verify required tools
for _tool in lspci grep; do
    command -v "$_tool" &>/dev/null || error_exit "$_tool not found. Please install pciutils / grep."
done

# PCI IDs supported by the broadcom-wl driver (vendor:device, lowercase).
# NOTE: Newer chips BCM43602/4364/4377/4378/4387 use the open-source brcmfmac driver
# from linux-firmware and are NOT compatible with the proprietary broadcom-wl module.
supported_ids=(
    # Legacy USB adapters
    "02d0:4345"
    "0846:9011" "0846:9020"
    "0a5c:bd17" "0a5c:bd1d"
    "1eda:2410"

    # BCM43xx PCIe (broadcom-wl supported)
    "14e4:0576"
    "14e4:4311" "14e4:4312" "14e4:4313" "14e4:4315"
    "14e4:4328" "14e4:4329" "14e4:432a" "14e4:432b" "14e4:432c" "14e4:432d"
    "14e4:4331"
    "14e4:4353" "14e4:4357" "14e4:4358" "14e4:4359"
    "14e4:4360"   # BCM4360 older variant — supported by broadcom-wl
    "14e4:4365"
    "14e4:43a0"   # BCM4360 second PCI ID variant
    "14e4:43b1"   # BCM4352
    "14e4:4727"
    "14e4:a8d6" "14e4:a99d"
    "14e4:0619"
)

# Chip names in the broadcom-wl supported family
chip_names=(
    BCM4311 BCM4312 BCM4313 BCM4321 BCM4322
    BCM43222 BCM43224 BCM43225 BCM43227 BCM43228 BCM43229 BCM43231 BCM43236
    BCM43241 BCM43242 BCM4330 BCM4331 BCM4334 BCM4335 BCM4339 BCM4345
    BCM43421 BCM43430 BCM43455
    BCM4350 BCM4352 BCM4354 BCM4356 BCM4358 BCM4359 BCM4360
    BCM4365 BCM4366
    BCM4716 BCM4717 BCM4718
)

# Newer chips that require brcmfmac (open-source), not broadcom-wl
brcmfmac_chip_names=( BCM43602 BCM4364 BCM4377 BCM4378 BCM4387 )

log_info "$(date '+%Y-%m-%d %H:%M:%S') - Broadcom WiFi detection starting..."
log_info "Scanning PCI bus for Broadcom network devices..."

wifi_devices=$(lspci -nn | grep -iP 'network|wireless' | grep -i 'Broadcom' || true)

if [[ -z "$wifi_devices" ]]; then
    log_info "No Broadcom WLAN device found, nothing changed."
    log_info "==== lspci -nn network devices ===="
    lspci -nn | grep -iP 'network|wireless' | tee -a "$LOG_FILE" || true
    log_info "===================================="
    exit 1
fi

log_info "Detected Broadcom WLAN device(s):"
log "$wifi_devices"
log ""

supported_found=0
found_id=""
brcmfmac_hint=0

while IFS= read -r line; do
    # Extract the last bracketed "vendor:device" pair (e.g. [14e4:4360])
    id=$(echo "$line" | grep -oP '\[[0-9a-f]{4}:[0-9a-f]{4}\]' | tr -d '[]' | tail -1 || true)
    log_info "Detected PCI ID: ${id:-<unknown>}"

    if [[ -n "$id" ]]; then
        if [[ " ${supported_ids[*]} " == *" $id "* ]]; then
            log_info "=> PCI $id is SUPPORTED by broadcom-wl."
            supported_found=1
            found_id="$id"
        else
            log_warn "=> PCI $id is not in the broadcom-wl supported list."
            chip=$(echo "$line" | grep -oP 'BCM[0-9]+' | head -1 || true)
            if [[ -n "$chip" ]]; then
                for _bcm in "${brcmfmac_chip_names[@]}"; do
                    if [[ "$chip" == "$_bcm" ]]; then
                        log_warn "=> $chip requires the open-source brcmfmac driver (linux-firmware), not broadcom-wl."
                        brcmfmac_hint=1
                        break
                    fi
                done
            fi
        fi
    else
        log_warn "=> Could not parse a PCI ID from this line; skipping ID check."
    fi

    chip=$(echo "$line" | grep -oP 'BCM[0-9]+' | head -1 || true)
    if [[ -n "$chip" ]] && printf "%s\n" "${chip_names[@]}" | grep -qxF "$chip"; then
        log_info "=> Chip name hint: $chip (broadcom-wl supported family)"
    fi

    log ""
    [[ $supported_found -eq 1 ]] && break
done <<< "$wifi_devices"

if [[ $supported_found -eq 1 ]]; then
    log_info "Broadcom-wl compatible device found (PCI ID: $found_id)."
    log_info "==== inxi -Naz output ===="
    inxi -Naz 2>/dev/null | tee -a "$LOG_FILE" || log_warn "inxi not available; skipping network info."
    log_info "=========================="

    WICON="/usr/share/endeavouros/EndeavourOS-icon.png"
    [[ -e "$WICON" ]] || WICON="dialog-information"
    YAD=(yad --window-icon="$WICON" --center --title='Broadcom wireless device management')

    if "${YAD[@]}" --image=dialog-question \
        --text="Broadcom-wl compatible device [$found_id] found.\nDo you want to run the install script?\n"; then
        log_info "User confirmed. Running install script..."
        /usr/bin/broadcom-wl_enable.sh >> "$LOG_FILE" 2>&1
        "${YAD[@]}" --image=dialog-information \
            --text="Script executed successfully (check $LOG_FILE for details)."
        log_info "Install script finished."
    else
        log_info "User declined. No changes made."
        "${YAD[@]}" --image=dialog-information \
            --text="Operation cancelled by user. Nothing changed."
    fi
    exit 0
else
    if [[ $brcmfmac_hint -eq 1 ]]; then
        log_warn "A newer Broadcom chip was found that requires brcmfmac (linux-firmware), not broadcom-wl."
    else
        log_info "No broadcom-wl compatible device found. Nothing changed."
    fi
    log_info "==== lspci -nn network devices ===="
    lspci -nn | grep -iP 'network|wireless' | tee -a "$LOG_FILE" || true
    log_info "===================================="
    exit 1
fi
