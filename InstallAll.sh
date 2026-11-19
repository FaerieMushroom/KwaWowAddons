#!/usr/bin/env bash
# Install all Kwa addons to WoW Forever (Proton / Steam)
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install dependencies first, then the addons that use them.
ADDONS=(
    "KwaLite"
    "KwaUtils"
    "KwaKillCounter"
    "KwaXpTracker"
    "KwaAuctionSearch"
    "KwaPetSkills"
    "KwaUnitLabeler"
    "KwaProfiler"
    "KwaBankSearch"
)

for addon in "${ADDONS[@]}"; do
    script="$ROOT_DIR/$addon/install.sh"
    if [[ ! -f "$script" ]]; then
        echo "Missing installer: $script" >&2
        exit 1
    fi

    echo
    echo "==> Installing $addon"
    bash "$script"
done

echo
echo "All Kwa addons installed."
