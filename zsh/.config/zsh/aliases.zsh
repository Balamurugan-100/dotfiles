# aliases.zsh — shell aliases

# Quick
alias c='clear'
alias v='nvim'
alias g='git'
alias l='eza --icons always'
alias la='eza -la --icons always'
alias lt='eza --tree --level=2 --icons always'

# Git
alias ga='git add'
alias gs='git status'
alias gd='git diff'
alias glo='git log --oneline'
alias gsh='git show'
alias grs='git restore'
alias gco='git checkout'
alias gsw='git switch'
alias gpl='git pull'
alias gps='git push'
alias lg='lazygit'
alias ld='lazydocker'

# Commit shortcuts
alias gcmsg='git commit -m'
alias gcam='git commit -am'
alias gfix='git commit -m "fix: "'
alias gfeat='git commit -m "feat: "'
alias gdocs='git commit -m "docs: "'
alias gref='git commit -m "refactor: "'

# Nvim with different configs
alias kick='NVIM_APPNAME=kick nvim'
alias astro='NVIM_APPNAME=astro nvim'
alias lazy='NVIM_APPNAME=lazy nvim'

# Tools
alias oc='opencode'
alias studio='open -a "Android Studio"'
alias rest='~/scripts/pomodoro.sh REST 10'
