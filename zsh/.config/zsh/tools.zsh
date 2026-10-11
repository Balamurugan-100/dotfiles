
source <(fzf --zsh)

eval "$(zoxide init --cmd cd zsh)"

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/zen.toml)"
eval "$(atuin init zsh)"
fpath=(~/.zsh/completions $fpath)
eval "$(mise activate zsh)"
