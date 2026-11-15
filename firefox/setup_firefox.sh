#!/usr/bin/env bash
# ==============================================================================
# setup_firefox.sh — Reproduce Firefox Catppuccin Mocha Profile on Linux & macOS
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }

candidate_roots=(
    "$HOME/snap/firefox/common/.mozilla/firefox"
    "$HOME/.mozilla/firefox"
    "$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox"
    "$HOME/Library/Application Support/Firefox/Profiles"
    "$HOME/Library/Application Support/Mozilla/Firefox/Profiles"
)

found_profile=0

apply_to_profile() {
    local profile_dir="$1"

    info "Applying Catppuccin Mocha + Zen UI profile to: ${profile_dir}"

    mkdir -p "${profile_dir}/chrome"

    # Link or copy user.js
    ln -sf "${SCRIPT_DIR}/user.js" "${profile_dir}/user.js" 2>/dev/null || cp -f "${SCRIPT_DIR}/user.js" "${profile_dir}/user.js"

    # Link or copy chrome stylesheets
    ln -sf "${SCRIPT_DIR}/chrome/userChrome.css" "${profile_dir}/chrome/userChrome.css" 2>/dev/null || cp -f "${SCRIPT_DIR}/chrome/userChrome.css" "${profile_dir}/chrome/userChrome.css"
    ln -sf "${SCRIPT_DIR}/chrome/userContent.css" "${profile_dir}/chrome/userContent.css" 2>/dev/null || cp -f "${SCRIPT_DIR}/chrome/userContent.css" "${profile_dir}/chrome/userContent.css"

    success "Configured ${profile_dir}"
    found_profile=1
}

for root in "${candidate_roots[@]}"; do
    if [[ -d "$root" ]]; then
        while IFS= read -r pdir; do
            if [[ -d "$pdir" ]]; then
                apply_to_profile "$pdir"
            fi
        done < <(find "$root" -maxdepth 2 -type f \( -name "prefs.js" -o -name "compatibility.ini" \) -exec dirname {} + 2>/dev/null | sort -u)
    fi
done

if [[ $found_profile -eq 0 ]]; then
    warn "No existing Firefox profile found."
    warn "Launch Firefox once to initialize a default profile, then rerun this script."
else
    success "All detected Firefox profiles are now configured with Catppuccin Mocha + Zen UI!"
fi
