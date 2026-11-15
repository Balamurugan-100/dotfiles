#!/usr/bin/env bash
# ==============================================================================
# mac_install.sh — Complete macOS Bootstrap & Dotfiles Setup
# Installs Homebrew packages, AeroSpace, Kitty, editors, mise tools, & browser profiles
# ==============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

step()    { echo -e "\n${BLUE}==>${NC} ${GREEN}$*${NC}"; }
info()    { echo -e "  ${BLUE}[INFO]${NC} $*"; }
warn()    { echo -e "  ${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "  ${RED}[ERROR]${NC} $*"; exit 1; }

# Verify running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    error "mac_install.sh is intended for macOS only. Use install.sh or hypr_install.sh on Ubuntu/Linux."
fi

# ── 1. Xcode Command Line Tools ───────────────────────────────────────────────
step "1. Checking Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode Command Line Tools..."
    xcode-select --install || true
    echo "Press return when the Xcode CLI installer has completed."
    read -r
fi

# ── 2. Homebrew ───────────────────────────────────────────────────────────────
step "2. Checking Homebrew..."
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -d "/opt/homebrew/bin" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d "/usr/local/bin" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    info "Homebrew found. Updating brew..."
    brew update
fi

# ── 3. Base Host Dependencies & GUI Casks ──────────────────────────────────────
step "3. Installing minimal host bootstrap & GUI casks..."
brew_formulas=(
    git
    zsh
    stow
    mise
)

for pkg in "${brew_formulas[@]}"; do
    if brew list "$pkg" &>/dev/null; then
        info "$pkg already installed"
    else
        info "Installing $pkg..."
        brew install "$pkg" || warn "Failed to install $pkg, continuing..."
    fi
done

brew_casks=(
    nikitabobko/tap/aerospace
    kitty
    zed
    raycast
)

for cask in "${brew_casks[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
        info "$cask already installed"
    else
        info "Installing cask $cask..."
        brew install --cask "$cask" || warn "Failed to install $cask, continuing..."
    fi
done

# ── 4. Stow macOS Dotfiles ───────────────────────────────────────────────────
step "4. Stowing configurations into ~/..."
mac_packages=(
    aerospace
    kitty
    nvim
    tmux
    lazygit
    btop
    zed
    atuin
    oh-my-posh
    zsh
    git
)

for pkg in "${mac_packages[@]}"; do
    if [[ -d "${DOTFILES_DIR}/${pkg}" ]]; then
        info "Stowing ${pkg} → ~/..."
        stow -v -d "${DOTFILES_DIR}" -t "${HOME}" --restow "${pkg}" 2>&1 | tail -1
    else
        warn "Package ${pkg} directory not found, skipping."
    fi
done

# ── 5. Mise Polyglot Runtimes ─────────────────────────────────────────────────
step "5. Installing mise tools from config..."
if command -v mise &>/dev/null; then
    mise install -y || warn "mise install finished with warnings"
    export PATH="$HOME/.local/share/mise/shims:$PATH"
fi

# ── 6. TPM (Tmux Plugin Manager) ─────────────────────────────────────────────
step "6. Setting up Tmux Plugins..."
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    "$TPM_DIR/bin/install_plugins" || true
fi

# ── 7. Browser Profiles (Zen & Firefox) ──────────────────────────────────────
step "7. Applying Catppuccin Mocha Browser Profiles..."
if [[ -f "${DOTFILES_DIR}/zen/setup_zen.sh" ]]; then
    info "Setting up Zen browser profile..."
    "${DOTFILES_DIR}/zen/setup_zen.sh" || true
fi

if [[ -f "${DOTFILES_DIR}/firefox/setup_firefox.sh" ]]; then
    info "Setting up Firefox profile..."
    "${DOTFILES_DIR}/firefox/setup_firefox.sh" || true
fi

# ── 8. AeroSpace Startup ─────────────────────────────────────────────────────
step "8. Setting up AeroSpace..."
if command -v aerospace &>/dev/null; then
    aerospace reload-config || true
fi

echo ""
info "🎉 macOS Dotfiles installation & bootstrap complete!"
echo ""
echo "  Core Keybindings on macOS (AeroSpace):"
echo "    Alt + T / Return     → Kitty Terminal"
echo "    Alt + B              → Zen / Firefox Browser"
echo "    Alt + Space          → Raycast Search & App Launcher"
echo "    Alt + V              → Raycast Clipboard History"
echo "    Alt + . (Period)     → Raycast Emoji Picker"
echo "    Alt + C              → Neovim (Kitty)"
echo "    Alt + Z              → Zed GUI Editor"
echo "    Alt + H / L / K / J  → Focus Window (Vim keys)"
echo "    Alt + 1 .. 0         → Numbered Workspaces 1-10"
echo "    Alt + Shift + 1 .. 0 → Move Window to Workspace 1-10"
echo ""
