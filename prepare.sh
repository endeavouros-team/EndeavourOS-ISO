#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
readonly BUILD_LOCK="/tmp/eos-build.lock"
readonly SCRIPT_NAME="$(basename "$0")"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
log()  { echo "[$(date '+%H:%M:%S')] ${SCRIPT_NAME}: $*"; }
die()  { echo "${SCRIPT_NAME}: error: $*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Cleanup – called on EXIT (success or failure)
# ---------------------------------------------------------------------------
cleanup() {
    local exit_code=$?
    if [[ -f "$BUILD_LOCK" ]] && [[ "$(cat "$BUILD_LOCK")" == "$$" ]]; then
        rm -f "$BUILD_LOCK"
        log "Build lock released."
    fi
    if [[ $exit_code -ne 0 ]]; then
        log "Build failed (exit code ${exit_code}). Check output above for errors."
    fi
}
trap cleanup EXIT

# ---------------------------------------------------------------------------
# Safety: refuse to run as root (makepkg requires a non-root user)
# ---------------------------------------------------------------------------
if [[ $EUID -eq 0 ]]; then
    die "Do not run ${SCRIPT_NAME} as root. makepkg requires a non-root user."
fi

# ---------------------------------------------------------------------------
# Dependency check
# ---------------------------------------------------------------------------
log "Checking required build dependencies..."
missing_deps=()
for cmd in git makepkg curl wget magick reflector sudo pacman; do
    if ! command -v "$cmd" &>/dev/null; then
        missing_deps+=("$cmd")
    fi
done
if [[ ${#missing_deps[@]} -gt 0 ]]; then
    die "Missing required tools: ${missing_deps[*]}. Install them and re-run."
fi
log "All required tools found."

# ---------------------------------------------------------------------------
# Build lock – prevent concurrent builds
# ---------------------------------------------------------------------------
if [[ -f "$BUILD_LOCK" ]]; then
    existing_pid="$(cat "$BUILD_LOCK" 2>/dev/null || true)"
    if [[ -n "$existing_pid" ]] && kill -0 "$existing_pid" 2>/dev/null; then
        die "Another build is already running (PID ${existing_pid}). Remove ${BUILD_LOCK} if it is stale."
    else
        log "Removing stale build lock (PID ${existing_pid} no longer running)."
        rm -f "$BUILD_LOCK"
    fi
fi
echo "$$" > "$BUILD_LOCK"
log "Build lock acquired (PID $$)."

# ---------------------------------------------------------------------------
# add date to wallpaper
log "Adding build date to wallpaper..."
cp airootfs/root/livewall.png airootfs/root/livewall-original.png

magick airootfs/root/livewall.png \
  -gravity NorthEast \
  -pointsize 24 \
  -fill white \
  -font "DejaVu-Sans" \
  -annotate +10+10 "$(date '+%Y-%m-%d')" \
  airootfs/root/livewall.png
log "Wallpaper date annotation done."

# Get wallpaper for installed system
log "Downloading endeavouros-wallpaper.png..."
wget -qN --show-progress -P "airootfs/root/" "https://raw.githubusercontent.com/endeavouros-team/Branding/master/backgrounds/endeavouros-wallpaper.png" \
    || die "failed to download endeavouros-wallpaper.png"
log "Wallpaper download done."

# Make sure build scripts are executable
log "Setting build scripts executable..."
chmod +x "./"{"mkarchiso","run_before_squashfs.sh"}

# uncomment to comment calamares package in packages.x86_64 in case you use local build of it
#[ -n "$(ls airootfs/root/packages/*calamares* 2>/dev/null)" ] && sed -i '/calamares/ s/^/#/' packages.x86_64


get_pkg() {
    local pkg="$1"
    local pkg_cache
    pkg_cache="$(mktemp -d)"
    log "Downloading package: ${pkg}..."
    sudo pacman -Syw "$pkg" --cachedir "$pkg_cache" --noconfirm \
        || { die "failed to download package '${pkg}'"; rm -rf "$pkg_cache"; return 1; }
    sudo cp "$pkg_cache"/*.pkg.tar.zst airootfs/root/packages/ \
        || { die "failed to copy package '${pkg}' to packages dir"; rm -rf "$pkg_cache"; return 1; }
    sudo chown "$USER:$USER" "airootfs/root/packages/"*".pkg.tar"*
    rm -rf "$pkg_cache"
    log "Package '${pkg}' ready."
}

get_pkg "eos-settings-plasma"

# Build liveuser skel
log "Building liveuser skel package..."
cd "airootfs/root/endeavouros-skel-liveuser"
makepkg -f
log "Liveuser skel build done."
log "prepare.sh completed successfully."
