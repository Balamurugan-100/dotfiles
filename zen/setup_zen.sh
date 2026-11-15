#!/usr/bin/env bash
# ==============================================================================
# setup_zen.sh — Reproduce Zen & Firefox Catppuccin Profiles on Any Machine
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
    "$HOME/.var/app/app.zen_browser.zen/.zen"
    "$HOME/.zen"
    "$HOME/Library/Application Support/zen/Profiles"
    "$HOME/Library/Application Support/Zen/Profiles"
)

found_profile=0

apply_to_profile() {
    local profile_dir="$1"
    local browser_name="$2"

    info "Applying profile to ${browser_name}: ${profile_dir}"

    mkdir -p "${profile_dir}/chrome"

    # Link user.js
    ln -sf "${SCRIPT_DIR}/user.js" "${profile_dir}/user.js"

    # Link chrome stylesheets
    ln -sf "${SCRIPT_DIR}/chrome/userChrome.css" "${profile_dir}/chrome/userChrome.css"
    ln -sf "${SCRIPT_DIR}/chrome/userContent.css" "${profile_dir}/chrome/userContent.css"

    success "Configured ${profile_dir}"
    found_profile=1
}

for root in "${candidate_roots[@]}"; do
    if [[ -d "$root" ]]; then
        # Look for profile directories containing prefs.js or compatibility.ini
        while IFS= read -r pdir; do
            if [[ -d "$pdir" ]]; then
                apply_to_profile "$pdir" "$(basename "$root")"
            fi
        done < <(find "$root" -maxdepth 2 -type f \( -name "prefs.js" -o -name "compatibility.ini" \) -exec dirname {} + 2>/dev/null | sort -u)
    fi
done

if [[ $found_profile -eq 0 ]]; then
    warn "No existing Zen or Firefox profile found."
    warn "Please launch Zen or Firefox once so it creates a profile, then rerun this script."
else
    success "All detected Zen/Firefox profiles are now configured with Catppuccin Mocha!"
fi
