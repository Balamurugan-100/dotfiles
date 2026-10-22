bindkey -v
export KEYTIMEOUT=1
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" history-search-backward
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" history-search-forward

function zle-keymap-select {
    case $KEYMAP in
        vicmd)
            print -n -- '\e[5 q'  # blinking beam — NORMAL
            ;;
        viins|main)
            print -n -- '\e[6 q'  # steady beam — INSERT
            ;;
    esac
}
zle -N zle-keymap-select


function zle-line-init {
    zle -K viins
}
zle -N zle-line-init

