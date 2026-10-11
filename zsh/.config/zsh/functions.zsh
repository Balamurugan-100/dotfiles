
function workon() {
    local env_name="$1"
    local venv

    local -a venv_paths=(
        "$HOME/.virtualenvs/$env_name"
        "$HOME/workspace/$env_name"
    )

    for venv in "${venv_paths[@]}"; do
        if [[ -f "$venv/bin/activate" ]]; then
            source "$venv/bin/activate" || return 1
            echo "Activated $env_name from $venv"
            return 0
        fi
    done

    echo "Virtualenv '$env_name' not found" >&2
    return 1
}
