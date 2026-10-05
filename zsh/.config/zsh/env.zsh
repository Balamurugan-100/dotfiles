export EDITOR="nvim"
export VISUAL="nvim"

export GPG_TTY="$(tty)"

if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PYENV_ROOT="$HOME/.pyenv"
export PYENV_REHASH_DISABLE=1

export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"

export PNPM_HOME="$HOME/Library/pnpm"

export DATABASE_NAME="testpress"
export DATABASE_USER="testpress"
export DATABASE_USER_PASSWORD='testpress1$'

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

