#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail

script_cmdline() {
    local param
    for param in $(</proc/cmdline); do
        case "${param}" in
            script=*)
                echo "${param#*=}"
                return 0
                ;;
        esac
    done
}

automated_script() {
    local script rt startup_script
    script="$(script_cmdline)"
    startup_script="$(mktemp /tmp/startup_script.XXXXXX)"
    if [[ -n "${script}" ]]; then
        if [[ "${script}" =~ ^((http|https|ftp|tftp)://) ]]; then
            # there's no synchronization for network availability before executing this script
            printf '%s: waiting for network-online.target\n' "$0"
            until systemctl --quiet is-active network-online.target; do
                sleep 1
            done
            printf '%s: downloading %s\n' "$0" "${script}"
            curl "${script}" --location --retry-connrefused --retry 10 --fail -s -o "${startup_script}"
            rt=$?
        else
            cp "${script}" "${startup_script}"
            rt=$?
        fi
        if [[ ${rt} -eq 0 ]]; then
            chmod +x "${startup_script}"
            printf '%s: executing automated script\n' "$0"
            # note that script is executed when other services (like pacman-init) may be still in progress, please
            # synchronize to "systemctl is-system-running --wait" when your script depends on other services
            "${startup_script}"
        else
            printf '%s: error: failed to obtain startup script from %s\n' "$0" "${script}" >&2
        fi
        rm -f "${startup_script}"
    fi
}

if [[ $(tty) == "/dev/tty1" ]]; then
    automated_script
fi
