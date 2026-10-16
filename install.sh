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
    error "stow not found. Install it before running this script."
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
remove_if_not_symlink "$HOME/.taskrc"
remove_if_not_symlink "$HOME/.profile"

# .config directory symlinks
for dir in nvim kitty tmux tmuxp starship ghostty lazygit mise btop aerospace shell broot cava zed atuin doom oh-my-posh; do
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
packages=(
    nvim kitty tmux tmuxp starship ghostty lazygit mise btop
    aerospace shell broot cava zed atuin doom oh-my-posh
    bash zsh git task profile
)

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

# ─── 6. Create secrets files if they don't exist ─────────────────────────────
BASH_SECRETS_FILE="$HOME/.config/bash/secrets.sh"
if [[ ! -f "$BASH_SECRETS_FILE" ]]; then
    info "Creating bash secrets.sh from template..."
    mkdir -p "$(dirname "$BASH_SECRETS_FILE")"
    cp "$DOTFILES_DIR/bash/.config/bash/secrets.sh.template" "$BASH_SECRETS_FILE"
    chmod 600 "$BASH_SECRETS_FILE"
    warn "Please edit $BASH_SECRETS_FILE with your actual API keys and tokens"
fi

# ─── 7. TPM (Tmux Plugin Manager) ────────────────────────────────────────────
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

# ─── 9. Post-install ────────────────────────────────────────────────────────
echo ""
info "✅ Dotfiles setup complete!"
echo ""
echo "  Packages stowed: ${#packages[@]}"
echo "  Secrets file:    $BASH_SECRETS_FILE"
echo ""
echo "  Next steps:"
echo "    1. Edit the secrets file with your API keys"
echo "    2. Restart your terminal"
echo "    3. Run 'tmux source ~/.config/tmux/tmux.conf' to reload tmux"
echo ""
