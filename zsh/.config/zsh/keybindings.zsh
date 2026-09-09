# keybindings.zsh — bindkey overrides

# fzf keybindings
if (( $+commands[fzf] )); then
  # Ctrl+R — history search
  bindkey '^R' fzf-history-widget
  # Ctrl+T — file search
  bindkey '^T' fzf-file-widget
  # Alt+C — directory search
  bindkey '\ec' fzf-cd-widget
fi

# Autosuggestions accept
bindkey '^[[C' forward-word
bindkey '^[f' forward-word

# Home/End
bindkey '^[[H' beginning-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[OF' end-of-line

# Delete
bindkey '^[[3~' delete-char
