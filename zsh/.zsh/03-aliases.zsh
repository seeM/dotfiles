alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias vi='vim'

alias psql="/Applications/Postgres.app/Contents/Versions/10/bin/psql"

alias venv='source .venv/bin/activate'

# -h : human-readable file sizes (bytes, etc.)
# -a : show hidden files
# -l : list files
# -G : colorize output
alias ls='ls -G'
alias l='ls'
alias ll='ls -halG'

alias e="vim"

# Git
alias g="git"
alias ga="git add"
alias gc="git commit"
alias gs="git status"
alias gd="git diff"
alias gf="git fetch"
alias gm="git merge"
alias gr="git rebase"
alias gp="git push"
alias gl="git pull"
alias gu="git unstage"
alias gg="git graph"
alias ggg="git graphgpg"
alias gco="git checkout"
alias gpr="hub pull-request"

# docker
alias dcd='docker compose down'
alias dcu='docker compose up'
alias lzd='lazydocker'

# Misc
alias tag='ctags --recurse --exclude=.venv --exclude=venv --python-kinds=-i .'

# Configs
alias vrc='vim ~/.vimrc'
alias zrc='vim ~/.zshrc'
alias trc='vim ~/.tmux.conf'

# Tmux
function t() {
    if [[ $# -eq 0 ]]; then
        # If no args, try to attach to a session, create a new session
        # if none exist.
        tmux attach-session 1>/dev/null 2>&1 || tmux new-session
    else
        # If args, try to attach to that session with that name if it exists,
        # otherwise create a new session.
        tmux new-session -A -s $1
    fi
}
alias tl="tmux list-sessions"
function ta() {
    target_session=$1
    if [[ $# -eq 0 ]]; then
        tmux attach-session
    else
        tmux attach-session -t $target_session
    fi
}
alias tn="tmux new-session -s"
alias td="tmux detach-client"

# Note-taking and journalling
alias pnotes='ranger ~/gdrive'
alias wnotes='ranger ~/gdrive-dp'

JOURNAL_DIR=~/gdrive/journal

# Open today's journal entry.
function journal_today() {
    date=$(date +'%Y-%m-%d')
    file=$JOURNAL_DIR/$date.md
    if ! test -f $file; then
        echo "# $date\n\n" > $file
    fi
    vim + '+ normal $' $file
}

# Main journal entrypoint.
function jrnl() {
    if [[ $# -eq 0 ]]; then
        journal_today
    elif [[ "$1" == "ls" ]]; then
        ranger "$JOURNAL_DIR"
    # TODO: Add elif that checks if an entry exists for the arg and opens it.
    #       Could even filter down by year / month in a vim buffer or similar...
    fi
}

