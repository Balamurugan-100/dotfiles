# functions.zsh — custom functions

mkcd() { mkdir -p "$1" && cd "$1" }

up() {
  local levels=${1:-1}
  local i
  for i in {1..$levels}; do
    cd ..
  done
}

extract() {
  [[ ! -f "$1" ]] && echo "File does not exist" && return 1
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.rar)     unrar x "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.tar)     tar xf "$1" ;;
    *.tbz2)    tar xjf "$1" ;;
    *.tgz)     tar xzf "$1" ;;
    *.zip)     unzip "$1" ;;
    *.7z)      7z x "$1" ;;
    *)         echo "Unknown archive format: $1" ;;
  esac
}

workon() {
  local env_name="$1"
  [[ -z "$env_name" ]] && echo "Usage: workon <env_name>" && return 1

  local venv_paths=(
    ~/.virtualenvs/$env_name
    ~/workspace/$env_name
  )

  for path in $venv_paths; do
    if [[ -f "$path/bin/activate" ]]; then
      source "$path/bin/activate"
      echo "Activated $env_name from $path"
      return
    fi
  done

  echo "Virtualenv '$env_name' not found"
  return 1
}

work() {
  local duration=${1:-40}
  ~/scripts/pomodoro.sh WORK $duration
}

ts() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf)
  [[ -n "$session" ]] && tmux switch-client -t "$session"
}

dev() {
  local workspace="$HOME/workspace"
  [[ ! -d "$workspace" ]] && echo "Workspace not found: $workspace" && return 1

  local project
  if [[ $# -gt 0 ]]; then
    project="$1"
  else
    command -v fzf >/dev/null || { echo "fzf is not installed"; return 1 }
    local projects
    projects=$(find "$workspace" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)
    [[ -z "$projects" ]] && echo "No projects found" && return 1
    project=$(echo "$projects" | fzf --layout=reverse --height=70% --border --prompt="⚡ " --header="Select a project")
    [[ -z "$project" ]] && return
  fi

  local path="$workspace/$project"
  [[ ! -d "$path" ]] && echo "Project not found: $project" && return 1
  command -v tmux >/dev/null || { echo "tmux is not installed"; return 1 }

  local session="${project//[^a-zA-Z0-9]/_}"
  session="${session:l}"

  tmux has-session -t="$session" 2>/dev/null || tmux new-session -d -s "$session" -c "$path"

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$session"
  else
    tmux attach-session -t "$session"
  fi
}
