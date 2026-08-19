#!/usr/bin/env fish

function dev --description "Open a workspace project in tmux"

    set -l workspace "$HOME/workspace"

    if not test -d "$workspace"
        echo "❌ Workspace not found: $workspace"
        return 1
    end

    # Pick project
    if test (count $argv) -gt 0
        set -l project $argv[1]
    else
        command -q fzf; or begin
            echo "❌ fzf is not installed"
            return 1
        end

        set -l projects (
            find "$workspace" \
                -mindepth 1 \
                -maxdepth 1 \
                -type d \
                -exec basename {} \; |
            sort
        )

        test (count $projects) -gt 0; or begin
            echo "❌ No projects found"
            return 1
        end

        set project (
            printf "%s\n" $projects |
            fzf \
                --layout=reverse \
                --height=70% \
                --border \
                --prompt="⚡ " \
                --header="Select a project"
        )

        test -n "$project"; or return
    end

    set -l path "$workspace/$project"

    if not test -d "$path"
        echo "❌ Project not found: $project"
        return 1
    end

    command -q tmux; or begin
        echo "❌ tmux is not installed"
        return 1
    end

    # Safe tmux session name
    set -l session (
        string lower (
            string replace -ra '[^[:alnum:]]+' '_' "$project"
        )
    )

    # Create the session if it doesn't exist.
    tmux has-session -t="$session" 2>/dev/null
    if test $status -ne 0
        tmux new-session -d \
            -s "$session" \
            -c "$path"
    end

    # Inside tmux -> switch client.
    if set -q TMUX
        tmux switch-client -t "$session"
        return
    end

    # Outside tmux -> attach.
    tmux attach-session -t "$session"
end
