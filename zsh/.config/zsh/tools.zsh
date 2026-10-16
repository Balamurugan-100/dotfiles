# Mise may provide the tools initialized below, so activate it first.
fpath=(~/.zsh/completions $fpath)
eval "$(mise activate zsh)"

source <(fzf --zsh)
eval "$(zoxide init zsh --cmd cd)"
eval "$(atuin init zsh)"
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/zen.toml)"
