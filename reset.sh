#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Reset build artefacts to a clean state.
#
# Usage: ./reset.sh [--force] [--dry-run]
#   --force    Skip the interactive confirmation prompt.
#   --dry-run  Show what would be deleted without actually deleting anything.

set -euo pipefail

FORCE=false
DRY_RUN=false

for arg in "$@"; do
    case "$arg" in
        --force)   FORCE=true ;;
        --dry-run) DRY_RUN=true ;;
        *)
            echo "reset.sh: unknown option: $arg" >&2
            echo "Usage: $0 [--force] [--dry-run]" >&2
            exit 1
            ;;
    esac
done

# ---------------------------------------------------------------------------
# Build the list of targets so the user can review them before deletion.
# ---------------------------------------------------------------------------
declare -a TARGETS=(
    "work"
    "out"
    "airootfs/root/packages/*.pkg.tar.zst"
    "airootfs/root/packages/*.pkg.tar.zst.sig"
    "airootfs/root/endeavouros-skel-liveuser/pkg"
    "airootfs/root/endeavouros-wallpaper.png"
    "airootfs/root/endeavouros-skel-liveuser/*.pkg.tar.zst"
    "airootfs/etc/pacman.d/"
    "eosiso*.log"
)

echo "reset.sh: The following paths will be removed:"
for t in "${TARGETS[@]}"; do
    # Use glob expansion to show only items that actually exist.
    for match in $t; do
        [[ -e "$match" ]] && echo "  - $match"
    done
done
# The livewall restore is a special case (move, not delete).
[[ -f "airootfs/root/livewall-original.png" ]] && \
    echo "  - airootfs/root/livewall-original.png -> airootfs/root/livewall.png (restore)"

if $DRY_RUN; then
    echo "reset.sh: dry-run mode – nothing was changed."
    exit 0
fi

# ---------------------------------------------------------------------------
# Confirm unless --force was given.
# ---------------------------------------------------------------------------
if ! $FORCE; then
    read -r -p "reset.sh: Proceed with deletion? [y/N] " answer
    case "$answer" in
        [yY][eE][sS]|[yY]) ;;
        *)
            echo "reset.sh: Aborted."
            exit 0
            ;;
    esac
fi

# ---------------------------------------------------------------------------
# Perform the cleanup.
# ---------------------------------------------------------------------------
rm -rf "work" "out"
rm -f airootfs/root/packages/*.pkg.tar.zst
rm -f airootfs/root/packages/*.pkg.tar.zst.sig
rm -rf airootfs/root/endeavouros-skel-liveuser/pkg
rm -f airootfs/root/endeavouros-wallpaper.png
rm -f airootfs/root/endeavouros-skel-liveuser/*.pkg.tar.zst
rm -rf airootfs/etc/pacman.d/
rm -f eosiso*.log
[[ -f "airootfs/root/livewall-original.png" ]] && \
    mv airootfs/root/livewall-original.png airootfs/root/livewall.png

echo "reset.sh: Clean complete."
