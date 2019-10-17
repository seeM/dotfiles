# Locale settings in pycharm don't seem to be set while settings in iTerm are
# correct. We explicitly set locale settings to make pycharm happy.
LC_ALL=en_US.UTF-8
LC_CTYPE=en_US.UTF-8
LANG=en_US.UTF-8

# Pyenv
PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# Macports
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

source ~/.zplug/init.zsh

zplug "mafredri/zsh-async"
zplug "sindresorhus/pure", use:pure.zsh, as:theme
zplug "zsh-users/zsh-autosuggestions", use:zsh-autosuggestions.zsh
zplug "zsh-users/zsh-history-substring-search", use:zsh-history-substring-search.zsh
zplug "plugins/osx", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh

# Use menu-styled completion
zstyle ':completion:*' menu select

# Source plugins and add commands to $PATH
zplug load

alias psql="/Applications/Postgres.app/Contents/Versions/10/bin/psql"

# Keymaps

# Currently commenting this out, in favour of trying emacs bindings since
# remapping caps lock to ctrl.
# VIM bindings
# bindkey -v    # vim mode
# export KEYTIMEOUT=1    # make vim mode transitions faster
# bindkey -M vicmd 'k' history-substring-search-up
# bindkey -M vicmd 'j' history-substring-search-down
# # Fix backscape button in vi mode
# bindkey "^?" backward-delete-char
## Fix delete button in vi mode
# bindkey -M vicmd "\e[3~" delete-char

# Standard Mac bindings
# fn + left/right: beginning/end of line
# Can't use cmd + left/right because iterm uses that to switch tabs.
# TODO: Maybe remap iterm to something more vim like?
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
# option + left/right: next/previous word
bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word

# Fix delete button
bindkey "\e[3~" delete-char

# Replace up and down (typically previous and next commands in the history) with
# a more powerful search from the zsh-history-substring-search plugin.
# NOTE: Changed from ctrl to meta modifier so that it doesn't break readline
#       ctrl-p and ctrl-n behaviour.
bindkey '^[p' history-substring-search-up
bindkey '^[n' history-substring-search-down
# TODO: Trying to disable in favor of emacs (ctrl+p/n), will see if I miss it?
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down

# Fix history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# TODO: Still not sure these are the best history settings.
setopt appendhistory EXTENDED_HISTORY

# =======
# Aliases
# =======
alias venv='source venv/bin/activate'

# -h : human-readable file sizes (bytes, etc.)
# -a : show hidden files
# -l : list files
# -G : colorize output
alias ls='ls -G'
alias a='ls -hal'

# Git
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gl='git pull'
alias gh='git push'
alias ga='git add'

# docker
alias dcd='docker compose down'
alias dcu='docker compose up'

alias lzd='lazydocker'

# Configs
alias vrc='vim ~/.vim/vimrc'
alias zrc='vim ~/.zshrc'
alias trc='vim ~/.tmux.conf'

# BasicTex
PATH="/Library/TeX/texbin:$PATH"

# Function for attaching to a remote tmux session via ssh
function ssh-tmux() {
    if [ "$1" != "" ]
    then
        ssh $1 -t tmux -CC a
    else
        ssh
    fi
}

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# added by pipx (https://github.com/pipxproject/pipx)
export PATH="/Users/seem/.local/bin:$PATH"

export PATH="/usr/local/opt/sqlite/bin:$PATH"

# Sqlite
alias sqlite="sqlite3 -column -header"

# Disables flow control (I think?) so we can use ctrl-s to forward search.
stty stop undef

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/seem/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/seem/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/seem/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/seem/google-cloud-sdk/completion.zsh.inc'; fi

# Note-taking
alias pnotes='ranger ~/DropBox'
alias wnotes='ranger ~/gdrive'

# -------------------------- Journalling ------------------------------
JOURNAL_DIR=~/DropBox/2_areas/journal

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

