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

# ─── 1. Homebrew ──────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    info "Homebrew already installed"
fi

# ─── 2. Brew Packages ────────────────────────────────────────────────────────
info "Installing brew packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ─── 3. GNU Stow ─────────────────────────────────────────────────────────────
if ! command -v stow &>/dev/null; then
    error "stow not found. Install with: brew install stow"
fi

# ─── 4. Remove conflicting existing files ────────────────────────────────────
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
for dir in fish nvim kitty tmux tmuxp starship ghostty lazygit mise btop aerospace shell broot cava zed atuin doom; do
    remove_if_not_symlink "$HOME/.config/$dir"
done

# Remove orphan nvim symlinks from .config
remove_if_not_symlink "$HOME/.config/init.lua"
remove_if_not_symlink "$HOME/.config/lua"
remove_if_not_symlink "$HOME/.config/lazy-lock.json"

# ─── 5. Stow Packages ────────────────────────────────────────────────────────
info "Stowing packages..."

# Packages that go to ~/.config/
config_packages=(
    fish nvim kitty tmux tmuxp starship ghostty
    lazygit mise btop aerospace shell broot cava zed
    atuin doom
)

# Packages that go to ~/ (home directory)
home_packages=(
    bash zsh git task profile
)

# Stow home directory packages
for pkg in "${home_packages[@]}"; do
    if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
        info "Stowing $pkg → ~/..."
        stow -v -d "$DOTFILES_DIR" -t "$HOME" --restow "$pkg" 2>&1 | tail -1
    else
        warn "Package $pkg not found, skipping"
    fi
done

# Stow .config/ packages
for pkg in "${config_packages[@]}"; do
    if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
        info "Stowing $pkg → ~/.config/..."
        stow -v -d "$DOTFILES_DIR" -t "$HOME/.config" --restow "$pkg" 2>&1 | tail -1
    else
        warn "Package $pkg not found, skipping"
    fi
done

# ─── 6. Create secrets file if it doesn't exist ──────────────────────────────
SECRETS_FILE="$HOME/.config/fish/secrets.fish"
if [[ ! -f "$SECRETS_FILE" ]]; then
    info "Creating secrets.fish from template..."
    cp "$DOTFILES_DIR/fish/.config/fish/secrets.fish.template" "$SECRETS_FILE"
    chmod 600 "$SECRETS_FILE"
    warn "Please edit $SECRETS_FILE with your actual API keys and tokens"
fi

# ─── 7. TPM (Tmux Plugin Manager) ────────────────────────────────────────────
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    info "Installing tmux plugins..."
    "$TPM_DIR/bin/install_plugins"
else
    info "TPM already installed"
fi

# ─── 8. Fisher (Fish Plugin Manager) ─────────────────────────────────────────
if command -v fish &>/dev/null; then
    if ! fish -c "type -q fisher" 2>/dev/null; then
        info "Installing Fisher..."
        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
        info "Installing fish plugins..."
        fish -c "fisher install"
    else
        info "Fisher already installed"
    fi
fi

# ─── 9. Neovim Plugins ──────────────────────────────────────────────────────
if command -v nvim &>/dev/null; then
    info "Syncing neovim plugins (headless)..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || warn "Neovim plugin sync skipped"
fi

# ─── 10. Set Fish as Default Shell ────────────────────────────────────────────
FISH_PATH="$(which fish)"
if [[ "$SHELL" != "$FISH_PATH" ]]; then
    info "Setting fish as default shell..."
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi
    chsh -s "$FISH_PATH"
    info "Default shell changed to fish. Restart your terminal."
else
    info "Fish is already the default shell"
fi

# ─── 11. Post-install ────────────────────────────────────────────────────────
echo ""
info "✅ Dotfiles setup complete!"
echo ""
echo "  Packages stowed: ${#config_packages[@]} config + ${#home_packages[@]} home"
echo "  Secrets file:    $SECRETS_FILE"
echo ""
echo "  Next steps:"
echo "    1. Edit secrets.fish with your API keys"
echo "    2. Restart your terminal"
echo "    3. Run 'tmux source ~/.config/tmux/tmux.conf' to reload tmux"
echo ""
