# env.zsh — exports: PATH, EDITOR, LANG, etc.

export EDITOR="nvim"
export VISUAL="nvim"
export LANG="en_IN.UTF-8"
export LC_ALL="en_IN.UTF-8"
export LC_CTYPE="en_IN.UTF-8"

# PATH
typeset -U path
path=(
  /opt/homebrew/bin
  ~/.local/bin
  ~/.cargo/bin
  ~/bin
  ~/.pyenv/bin
  ~/.antigravity/antigravity/bin
  ~/.antigravity-ide/antigravity-ide/bin
  ~/.opencode/bin
  "$ANDROID_HOME/cmdline-tools/latest/bin(N)"
  "$ANDROID_HOME/platform-tools(N)"
  "$ANDROID_HOME/emulator(N)"
  "$PNPM_HOME/bin(N)"
  $path
)

# Environment variables
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_REHASH_DISABLE=1
export DATABASE_NAME=testpress
export DATABASE_USER=testpress
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PNPM_HOME="$HOME/Library/pnpm"

# Secrets (gitignored)
[[ -f ~/.config/zsh/secrets.zsh ]] && source ~/.config/zsh/secrets.zsh
