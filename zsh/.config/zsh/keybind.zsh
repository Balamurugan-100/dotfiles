bindkey -e

bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

[[ -n ${key[Up]} ]]   && bindkey "${key[Up]}" history-search-backward
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" history-search-forward
