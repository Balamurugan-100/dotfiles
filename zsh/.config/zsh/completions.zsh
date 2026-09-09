# completions.zsh — compinit, completion styling, fzf integration

# fzf defaults
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

export FZF_DEFAULT_OPTS="
  --height 70%
  --layout=reverse
  --border
  --info=inline
  --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8
  --color=fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8
  --color=info:#cba6f7,prompt:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,spinner:#f5e0dc,header:#f38ba8
"

export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"

# fzf completion using fzf-tab
zstyle ':completion:complete:*:options' use-compctl true

# fzf-tab: use bat for preview
zstyle ':fzf-tab:complete:*' fzf-preview 'bat --color=always --style=numbers --line-range=:200 $realpath 2>/dev/null || ls -la $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -la $realpath 2>/dev/null'

# completion colors
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache"

# kill completion
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,comm'
zstyle ':completion:*:processes' menu yes select
zstyle ':completion:*:processes' force-list always
