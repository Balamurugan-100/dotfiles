#!/usr/bin/env bash
# ====================================================================
# Hyprland Desktop Environment Bootstrap & Installer
# Installs all required desktop packages, Wayle shell, Zen, Vicinae,
# syncs icons, installs mise tools, and stows configurations.
# ====================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
mkdir -p "${BIN_DIR}"
export PATH="${BIN_DIR}:${PATH}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
step()  { echo -e "\n${BLUE}==>${NC} ${GREEN}$1${NC}"; }

# ── 1. System Dependencies (APT) ──────────────────────────────────
step "1. Checking and installing system dependencies (APT)..."
APT_PACKAGES=(
    hyprland
    hyprpaper
    hyprlock
    hypridle
    hyprsunset
    kitty
    grim
    slurp
    wl-clipboard
    cliphist
    brightnessctl
    pavucontrol
    blueman
    network-manager-gnome
    libnotify-bin
    stow
    jq
    curl
    flatpak
)

MISSING_PACKAGES=()
for pkg in "${APT_PACKAGES[@]}"; do
    if ! dpkg -s "$pkg" &>/dev/null; then
        MISSING_PACKAGES+=("$pkg")
    fi
done

if [[ ${#MISSING_PACKAGES[@]} -gt 0 ]]; then
    info "Installing missing packages: ${MISSING_PACKAGES[*]}"
    sudo apt-get update
    sudo apt-get install -y "${MISSING_PACKAGES[@]}"
else
    info "All core APT packages are already installed."
fi

# Install hyprpolkitagent or polkit-gnome if missing
if [[ ! -f /usr/libexec/hyprpolkitagent && ! -f /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 ]]; then
    info "Installing polkit agent..."
    sudo apt-get install -y policykit-1-gnome || true
fi

# ── 2. Zen Browser (Flatpak) ──────────────────────────────────────
step "2. Checking Zen Browser..."
if ! flatpak list | grep -q "app.zen_browser.zen"; then
    info "Adding Flathub remote..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
    info "Installing Zen Browser via Flatpak..."
    flatpak install -y flathub app.zen_browser.zen || true
else
    info "Zen Browser is already installed via Flatpak."
fi

# Ensure ~/.local/bin/zen wrapper exists
cat << 'EOF' > "${BIN_DIR}/zen"
#!/usr/bin/env bash
exec flatpak run app.zen_browser.zen "$@"
EOF
chmod +x "${BIN_DIR}/zen"
info "Zen launcher verified at ${BIN_DIR}/zen"

# ── 3. Wayle Desktop Shell ────────────────────────────────────────
step "3. Checking Wayle Desktop Shell..."
WAYLE_VERSION="0.7.1"

if ! command -v wayle &>/dev/null; then
    info "Downloading Wayle v${WAYLE_VERSION}..."
    TMP_WAYLE=$(mktemp -d)
    DEB_URL="https://github.com/wayle-rs/wayle/releases/download/v${WAYLE_VERSION}/wayle_${WAYLE_VERSION}_amd64.deb"
    curl -fLo "${TMP_WAYLE}/wayle.deb" "${DEB_URL}"

    info "Extracting Wayle to ${HOME}/.local..."
    dpkg -x "${TMP_WAYLE}/wayle.deb" "${TMP_WAYLE}/extracted"
    cp "${TMP_WAYLE}/extracted/usr/bin/wayle"* "${BIN_DIR}/"
    chmod +x "${BIN_DIR}/wayle"*

    mkdir -p "${HOME}/.local/share/icons" "${HOME}/.local/share/applications"
    cp -r "${TMP_WAYLE}/extracted/usr/share/icons/"* "${HOME}/.local/share/icons/" 2>/dev/null || true
    cp -r "${TMP_WAYLE}/extracted/usr/share/applications/"* "${HOME}/.local/share/applications/" 2>/dev/null || true

    rm -rf "${TMP_WAYLE}"
    info "Wayle v${WAYLE_VERSION} installed to ${BIN_DIR}/wayle"
else
    info "Wayle is already installed: $(wayle --version)"
fi

info "Syncing Wayle symbolic icons..."
wayle icons sync || true

# ── 4. Vicinae Launcher ───────────────────────────────────────────
step "4. Checking Vicinae Launcher..."
if ! command -v vicinae &>/dev/null; then
    warn "Vicinae binary not found in PATH."
    info "Visit https://vicinae.com/docs to install Vicinae for your system."
else
    info "Vicinae is installed: $(vicinae version 2>/dev/null || which vicinae)"
    systemctl --user enable --now vicinae.service 2>/dev/null || true
fi

# ── 5. mise CLI Tools ─────────────────────────────────────────────
step "5. Installing mise tools from config..."
if command -v mise &>/dev/null; then
    info "Running mise install..."
    mise install -y || true
else
    warn "mise not found. Run ./install.sh to bootstrap mise."
fi

# ── 6. Stow Dotfiles ──────────────────────────────────────────────
step "6. Stowing Hyprland and Wayle configurations..."
for pkg in hypr wayle; do
    if [[ -d "${DOTFILES_DIR}/${pkg}" ]]; then
        info "Stowing ${pkg} → ~/..."
        stow -v -d "${DOTFILES_DIR}" -t "${HOME}" --restow "${pkg}" 2>&1 | tail -1
    fi
done

# Ensure all helper scripts have execute permissions
chmod +x "${DOTFILES_DIR}/hypr/.config/hypr/scripts/"*.sh 2>/dev/null || true

# ── 7. Verify Configuration ───────────────────────────────────────
step "7. Verifying Hyprland and Wayle configurations..."
if command -v Hyprland &>/dev/null; then
    Hyprland --verify-config
fi

echo ""
info "🎉 Hyprland environment setup complete!"
echo ""
echo "  Core Keybindings:"
echo "    Super + T / Return   → Kitty Terminal"
echo "    Super + B            → Zen Browser"
echo "    Super + Space        → Vicinae Launcher & Calculator"
echo "    Super + V            → Vicinae Clipboard History"
echo "    Super + . (Period)   → Vicinae Emoji Picker"
echo "    Alt + Tab            → Vicinae Visual Window Switcher"
echo "    Super + H / L        → Switch Windows (COSMIC wrap)"
echo "    Super + Shift + H/L  → Move / Swap Windows"
echo "    Super + Backspace    → Toggle Topbar (Mac menubar style)"
echo "    Super + Ctrl + N     → Toggle Night Light (4500K)"
echo "    Super + Q            → Quit Active Window"
echo "    Super + Ctrl+Shift+L → Lock Screen (Hyprlock)"
echo ""
