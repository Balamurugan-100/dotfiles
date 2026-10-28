# Mise may provide the tools initialized below, so activate it first.
fpath=(~/.zsh/completions $fpath)
eval "$(mise activate zsh)"

source <(fzf --zsh)
eval "$(zoxide init zsh --cmd cd)"
eval "$(atuin init zsh)"
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/zen.toml)"
eval $(thefuck --alias)

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

