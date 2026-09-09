# ~/.config/zsh/.zshrc — thin entrypoint, sources everything below

ZSH_DIR="${0:A:h}"

source "$ZSH_DIR/env.zsh"
source "$ZSH_DIR/options.zsh"
source "$ZSH_DIR/plugins.zsh"
source "$ZSH_DIR/completions.zsh"
source "$ZSH_DIR/aliases.zsh"
source "$ZSH_DIR/functions.zsh"
source "$ZSH_DIR/keybindings.zsh"

[[ -f "$ZSH_DIR/local.zsh" ]] && source "$ZSH_DIR/local.zsh"
