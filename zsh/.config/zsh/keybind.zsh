bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" history-search-backward
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" history-search-forward
