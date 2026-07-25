mkcd() {
    mkdir -p "$1" && cd "$1"
}

up() {
    local n="${1:-1}"
    while ((n--)); do
        cd ..
    done
}

extract() {
    [[ -f "$1" ]] || {
        echo "File not found"
        return 1
    }

    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.zip) unzip "$1" ;;
        *.rar) unrar x "$1" ;;
        *.7z) 7z x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *) echo "Unknown archive format" ;;
    esac
}

confirm() {
    read -rp "Continue? [y/N] " ans
    [[ "$ans" =~ ^[Yy]$ ]]
}

work() {
    "$HOME/scripts/pomodoro.sh" WORK "${1:-40}"
}

workon() {
    local env="$1"

    for path in \
        "$HOME/.virtualenvs/$env" \
        "$HOME/workspace/$env"
    do
        if [[ -f "$path/bin/activate" ]]; then
            source "$path/bin/activate"
            echo "Activated $env"
            return
        fi
    done

    echo "Virtualenv '$env' not found"
}

ts() {
    local session

    session=$(
        tmux list-sessions -F "#{session_name}" |
        fzf
    )

    [[ -n "$session" ]] &&
    tmux switch-client -t "$session"
}

dev() {
    local workspace="$HOME/workspace"
    local project path session

    [[ -d "$workspace" ]] || {
        echo "Workspace not found"
        return 1
    }

    if [[ $# -gt 0 ]]; then
        project="$1"
    else
        project=$(
            find "$workspace" \
                -mindepth 1 \
                -maxdepth 1 \
                -type d \
                -exec basename {} \; |
            sort |
            fzf \
                --layout=reverse \
                --height=70% \
                --border \
                --prompt="⚡ " \
                --header="Select a project"
        )
    fi

    [[ -n "$project" ]] || return

    path="$workspace/$project"

    [[ -d "$path" ]] || {
        echo "Project not found"
        return 1
    }

    session=$(echo "$project" |
        tr '[:upper:]' '[:lower:]' |
        sed 's/[^[:alnum:]]\+/_/g')

    tmux has-session -t "$session" 2>/dev/null ||
    tmux new-session -d \
        -s "$session" \
        -c "$path"

    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session"
    else
        tmux attach-session -t "$session"
    fi
}
