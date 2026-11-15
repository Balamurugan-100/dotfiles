#!/bin/bash
set -euo pipefail

# Dotfiles Bootstrap Script
# Usage: ./install.sh

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ─── 1. mise ─────────────────────────────────────────────────────────────────
if [[ ! -x "$HOME/.local/bin/mise" ]] && ! command -v mise &>/dev/null; then
    info "Installing mise..."
    curl -fsSL https://mise.run | sh
else
    info "mise already installed"
fi

export PATH="$HOME/.local/bin:$PATH"
info "mise $(mise --version)"


# ─── 2. GNU Stow ─────────────────────────────────────────────────────────────
if ! command -v stow &>/dev/null; then
    if command -v apt-get &>/dev/null; then
        info "Installing stow via apt..."
        sudo apt-get update -y && sudo apt-get install -y stow
    elif command -v brew &>/dev/null; then
        info "Installing stow via brew..."
        brew install stow
    else
        error "stow not found. Please install GNU Stow."
    fi
fi
fi

# ─── 3. Remove conflicting existing files ────────────────────────────────────
info "Removing conflicting existing configs..."

remove_if_not_symlink() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        warn "Backing up existing $target → ${target}.bak"
        mv "$target" "${target}.bak"
    elif [[ -L "$target" ]]; then
        rm "$target"
    fi
}

# Home directory dotfiles
remove_if_not_symlink "$HOME/.zshrc"
remove_if_not_symlink "$HOME/.bashrc"
remove_if_not_symlink "$HOME/.bash_profile"
remove_if_not_symlink "$HOME/.bash_aliases"
remove_if_not_symlink "$HOME/.bash_functions"
remove_if_not_symlink "$HOME/.gitconfig"
remove_if_not_symlink "$HOME/.gitignore_global"
remove_if_not_symlink "$HOME/.tmux.conf"
# .config directory symlinks
for dir in nvim kitty tmux lazygit mise btop zed atuin oh-my-posh hypr wayle vicinae zen; do
    remove_if_not_symlink "$HOME/.config/$dir"
done

# Remove orphan nvim symlinks from .config
remove_if_not_symlink "$HOME/.config/init.lua"
remove_if_not_symlink "$HOME/.config/lua"
remove_if_not_symlink "$HOME/.config/lazy-lock.json"

# ─── 4. Stow Packages ────────────────────────────────────────────────────────
info "Stowing packages..."

# All packages are laid out as .config/<name> (or dotfiles at the root),
# so they all stow into $HOME.
if [[ "$(uname)" == "Darwin" ]]; then
    packages=(
        aerospace nvim kitty tmux lazygit mise btop
        zed atuin oh-my-posh zsh git
    )
else
    packages=(
        nvim kitty tmux lazygit mise btop
        zed atuin oh-my-posh
        zsh git hypr wayle vicinae
    )
fi

for pkg in "${packages[@]}"; do
    if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
        info "Stowing $pkg → ~/..."
        stow -v -d "$DOTFILES_DIR" -t "$HOME" --restow "$pkg" 2>&1 | tail -1
    else
        warn "Package $pkg not found, skipping"
    fi
done

# ─── 5. Install mise tools ───────────────────────────────────────────────────
info "Installing mise tools from config..."
mise install

# Make mise-managed tools available to the rest of this script
export PATH="$HOME/.local/share/mise/shims:$PATH"

# ─── 6. TPM (Tmux Plugin Manager) ────────────────────────────────────────────
TPM_DIR="$HOME/.tmux/plugins/tpm"
if command -v tmux &>/dev/null; then
    if [[ ! -d "$TPM_DIR" ]]; then
        info "Installing TPM..."
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
        info "Installing tmux plugins..."
        "$TPM_DIR/bin/install_plugins"
    else
        info "TPM already installed"
    fi
fi

# ─── 8. Neovim Plugins ──────────────────────────────────────────────────────
if command -v nvim &>/dev/null; then
    info "Syncing neovim plugins (headless)..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || warn "Neovim plugin sync skipped"
fi

# ─── 8. Zen & Firefox Browser Profiles ─────────────────────────────────────
if [[ -f "$DOTFILES_DIR/zen/setup_zen.sh" ]]; then
    chmod +x "$DOTFILES_DIR/zen/setup_zen.sh"
    "$DOTFILES_DIR/zen/setup_zen.sh" || true
fi
if [[ -f "$DOTFILES_DIR/firefox/setup_firefox.sh" ]]; then
    chmod +x "$DOTFILES_DIR/firefox/setup_firefox.sh"
    "$DOTFILES_DIR/firefox/setup_firefox.sh" || true
fi

# ─── 9. Post-install ────────────────────────────────────────────────────────
echo ""
info "✅ Dotfiles setup complete!"
echo ""
echo "  Packages stowed: ${#packages[@]}"
echo ""
echo "  Next steps:"
echo "    1. Restart your terminal"
echo "    2. Run 'tmux source ~/.config/tmux/tmux.conf' to reload tmux"
echo ""
