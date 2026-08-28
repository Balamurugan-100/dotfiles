########## Shell Behavior ##########

set -g fish_greeting

if status is-login
    fish_add_path /opt/homebrew/bin
    fish_add_path ~/.local/bin
    fish_add_path ~/.cargo/bin
end

########## Environment ##########

set -Ux PYENV_ROOT $HOME/.pyenv
set -Ux PYENV_REHASH_DISABLE 1

fish_add_path $PYENV_ROOT/bin
fish_add_path ~/.antigravity/antigravity/bin
fish_add_path ~/.antigravity-ide/antigravity-ide/bin
# fish_add_path ~/.local/share/nvm/v22.19.0/bin
set -gx DATABASE_NAME testpress
set -gx DATABASE_USER testpress

# Source secrets (API keys, tokens, passwords) — secrets.fish is gitignored like .env
test -f ~/.config/fish/secrets.fish && source ~/.config/fish/secrets.fish

########## Abbreviations ##########

abbr -a c clear
abbr -a v nvim
abbr -a g git

abbr -a ga git add
abbr -a gs git status
abbr -a gd git diff
abbr -a glo 'git log --oneline'
abbr -a gsh git show
abbr -a grs git restore
abbr -a gco git checkout
abbr -a gsw git switch
abbr -a gpl git pull
abbr -a gps git push
abbr -a lg lazygit
abbr -a ld lazydocker
abbr -a l 'eza -l --icons'

abbr -a gcmsg --set-cursor 'git commit -m "%"'
abbr -a gcam --set-cursor 'git commit -am "%"'
abbr -a gfix --set-cursor 'git commit -m "fix: %"'
abbr -a gfeat --set-cursor 'git commit -m "feat: %"'
abbr -a gdocs --set-cursor 'git commit -m "docs: %"'
abbr -a gref --set-cursor 'git commit -m "refactor: %"'

abbr -a kick 'NVIM_APPNAME=kick nvim'
abbr -a astro 'NVIM_APPNAME=astro nvim'
abbr -a lazy 'NVIM_APPNAME=lazy nvim'

########## Functions ##########

function mkcd
    mkdir -p $argv[1]
    and cd $argv[1]
end

function up
    set levels 1

    if test (count $argv) -gt 0
        set levels $argv[1]
    end

    for i in (seq $levels)
        cd ..
    end
end

function extract
    if not test -f "$argv[1]"
        echo "File does not exist"
        return 1
    end

    switch $argv[1]
        case "*.tar.bz2"
            tar xjf $argv[1]
        case "*.tar.gz"
            tar xzf $argv[1]
        case "*.bz2"
            bunzip2 $argv[1]
        case "*.rar"
            unrar x $argv[1]
        case "*.gz"
            gunzip $argv[1]
        case "*.tar"
            tar xf $argv[1]
        case "*.tbz2"
            tar xjf $argv[1]
        case "*.tgz"
            tar xzf $argv[1]
        case "*.zip"
            unzip $argv[1]
        case "*.7z"
            7z x $argv[1]
        case '*'
            echo "Unknown archive format"
    end
end

function confirm
    read -l -P "Continue? [y/N] " response

    switch $response
        case Y y
            return 0
        case '*'
            return 1
    end
end

function fish_title
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo (basename (git rev-parse --show-toplevel))
    else
        echo (prompt_pwd)
    end
end

function work
    set duration 40

    if test (count $argv) -ge 1
        set duration $argv[1]
    end

    ~/scripts/pomodoro.sh WORK $duration
end

alias rest="~/scripts/pomodoro.sh REST 10"
alias oc="opencode"
alias studio='open -a "Android Studio"'

function workon
    set env_name $argv[1]

    set venv_paths \
        ~/.virtualenvs/$env_name \
        ~/workspace/$env_name

    for path in $venv_paths
        if test -f $path/bin/activate.fish
            source $path/bin/activate.fish
            echo "Activated $env_name from $path"
            return
        end
    end

    echo "Virtualenv '$env_name' not found"
    return 1
end

# function dev
#     if git rev-parse --show-toplevel >/dev/null 2>&1
#         set root (git rev-parse --show-toplevel)
#     else
#         set root (pwd)
#     end
#
#     set session (basename $root)
#     set session (string replace -a "." "_" $session)
#     set session (string replace -a " " "_" $session)
#
#     tmux has-session -t $session 2>/dev/null
#
#     if test $status -eq 0
#         if set -q TMUX
#             tmux switch-client -t $session
#         else
#             tmux attach-session -t $session
#         end
#     else
#         if set -q TMUX
#             tmux new-session -ds $session -c $root
#             tmux switch-client -t $session
#         else
#             tmux new-session -s $session -c $root
#         end
#     end
# end

function ts
    set session (tmux list-sessions -F "#{session_name}" | fzf)

    if test -n "$session"
        tmux switch-client -t $session
    end
end

function __fish_command_not_found_handler
    echo "Command not found: $argv[1]"

    if type -q brew
        echo
        echo "Homebrew suggestions:"
        brew search $argv[1]
    end
end

########## Interactive ##########

if status is-interactive

    starship init fish | source

    zoxide init fish | source

    # pyenv init - fish | source

    # rbenv init - --no-rehash fish | source

    fzf_configure_bindings \
        --directory=\cf \
        --git_log=\cg \
        --git_status=\cs

end

# Added by Antigravity CLI installer
set -gx PATH "/Users/bala/.local/bin" $PATH
# APPLE_* keys now live in secrets.fish (gitignored) — see secrets.fish.template
export ANDROID_HOME=$HOME/Library/Android/sdk
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $ANDROID_HOME/emulator

# pnpm
set -gx PNPM_HOME /Users/bala/Library/pnpm
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end
source ~/.config/fish/functions/dev.fish
atuin init fish | source

fish_add_path /home/kaizen/.strix/bin

export LANG=en_IN.utf8
export LC_ALL=en_IN.utf8

