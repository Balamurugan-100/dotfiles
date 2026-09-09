# plugins.zsh — zinit plugin manager + plugin list

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  command mkdir -p "$(dirname "$ZINIT_HOME")"
  command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# Syntax highlighting (load last, after compinit)
zinit ice atload"zicompinit; zicdreplay" lucid depth"1"
zinit light zsh-users/zsh-syntax-highlighting

# Autosuggestions
zinit ice lucid depth"1"
zinit light zsh-users/zsh-autosuggestions

# Completions (must load before compinit runs)
zinit ice lucid depth"1"
zinit light zsh-users/zsh-completions

# fzf-tab
zinit ice lucid depth"1"
zinit light Aloxaf/fzf-tab

# Prompt (robbyrussell)
autoload -Uz vcs_info

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' formats 'git:(%b%u)'
zstyle ':vcs_info:git:*' actionformats 'git:(%b|%a%u)'
zstyle ':vcs_info:git:*' unstagedstr ' %F{yellow}✗%f'
zstyle ':vcs_info:git:*' stagedstr ' %F{green}●%f'

precmd_functions+=(vcs_info)

setopt PROMPT_SUBST

PROMPT='%(?:%{%(!.$fg_bold[green].$fg_bold[red])%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%~%{$reset_color%} '
PROMPT+='%{$fg_bold[blue]%}${vcs_info_msg_0_}%{$reset_color%} '

# zoxide
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# atuin
if (( $+commands[atuin] )); then
  eval "$(atuin init zsh)"
fi
