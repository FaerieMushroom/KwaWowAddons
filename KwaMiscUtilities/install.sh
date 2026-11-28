#!/usr/bin/env bash
# Install KwaMiscUtilities to WoW Forever (Proton / Steam)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADDONS_DIR="/home/keira/.local/share/Steam/steamapps/compatdata/2880841926/pfx/drive_c/Program Files (x86)/World of Warcraft/_forever_/Interface/AddOns"
DEST_DIR="$ADDONS_DIR/KwaMiscUtilities"

# Remove the old XP tracker addon after the rename, otherwise the client would
# load both the old and new plugins.
rm -rf "$ADDONS_DIR/KwaXpTracker"
mkdir -p "$DEST_DIR"

for f in KwaMiscUtilities.toc KwaMiscUtilities.lua; do
    if [[ ! -f "$SCRIPT_DIR/$f" ]]; then
        echo "Missing file: $SCRIPT_DIR/$f" >&2
        exit 1
    fi
    cp -v "$SCRIPT_DIR/$f" "$DEST_DIR/"
done

echo "Installed to $DEST_DIR"
