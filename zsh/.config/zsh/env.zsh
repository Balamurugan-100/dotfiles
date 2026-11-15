export EDITOR="nvim"
export VISUAL="nvim"

export GPG_TTY="$(tty)"

if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PYENV_ROOT="$HOME/.pyenv"
export PYENV_REHASH_DISABLE=1

if [[ "$(uname)" == "Darwin" ]]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export PNPM_HOME="$HOME/Library/pnpm"
    export DYLD_LIBRARY_PATH="/opt/homebrew/lib:${DYLD_LIBRARY_PATH:-}"
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
else
    export ANDROID_HOME="$HOME/Android/Sdk"
    export PNPM_HOME="$HOME/.local/share/pnpm"
fi

export ANDROID_SDK_ROOT="$ANDROID_HOME"

export DATABASE_NAME="testpress"
export DATABASE_USER="testpress"
export DATABASE_USER_PASSWORD='testpress1$'
