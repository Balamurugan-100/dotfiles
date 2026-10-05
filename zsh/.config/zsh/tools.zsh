
source <(fzf --zsh)

eval "$(zoxide init --cmd cd zsh)"

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/new.toml)"
eval "$(mise activate zsh)"
eval "$(atuin init zsh)"
