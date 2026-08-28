### === PATH (Fedora sane defaults) === ###
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

### === Oh My Zsh === ###
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh

### === Completion UX === ###
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

### === Aliases === ###
alias cls='clear'
alias c='clear'
alias ls='eza --icons'
alias cat='bat'
alias gs='git status'
alias cgrep='grep --color=always'
alias lg='lazygit'
alias vi='nvim'

### === Django / Dev === ###
alias runhttps='python manage.py runserver_plus --cert-file cert.crt'

### === Neovim Profiles === ###
alias chad='NVIM_APPNAME="chad" nvim'
alias astro='NVIM_APPNAME="astro" nvim'
alias lazy='NVIM_APPNAME="lazyvim" nvim'
alias kick='NVIM_APPNAME="kick" nvim'

### === Editors === ###
export EDITOR='nvim'
export VISUAL='nvim'
export GIT_EDITOR='nvim'

### === Database Env (local dev only) === ###
export DATABASE_NAME="testpress"
export DATABASE_USER="testpress"
# DATABASE_USER_PASSWORD lives in secrets (gitignored, like .env) — see secrets.sh.template
[[ -f ~/.config/bash/secrets.sh ]] && source ~/.config/bash/secrets.sh
# Or for zsh-specific: [[ -f ~/.config/zsh/secrets.zsh ]] && source ~/.config/zsh/secrets.zsh

### === Starship Prompt === ###
eval "$(starship init zsh)"

### === FZF === ###
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS="
  --height 80%
  --layout=reverse
  --border
  --info=inline
  --preview 'bat --style=numbers --color=always --line-range=:200 {}'
  --preview-window=right:60%
"

# fzf → cd into directory
fzf_cd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git | fzf) && cd "$dir"
}
bindkey -s '^f' 'fzf_cd\n'

# Ripgrep + fzf file search
f() {
  rg --files --hidden --glob '!.git/*' 2>/dev/null \
    | fzf --preview "bat --color=always --line-range=:500 {}"
}

# Search command history
fh() {
  print -z "$(fc -l 1 | fzf --tac | sed 's/ *[0-9]* *//')"
}

### === Load fzf keybindings if present === ###
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

