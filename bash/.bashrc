# Source: https://github.com/seem/dotfiles
# References:
# - https://github.com/junegunn/dotfiles

# TODO: Move to install.sh
# git-prompt
if [ ! -e ~/.git-prompt.sh ]; then
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
fi

# System default
# --------------------------------------------------------------------

export PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc

# Trying to make git completion with aliases work on AWS ubuntu instances...
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Basics
# --------------------------------------------------------------------

# Append to history file, don't overwrite.
shopt -s histappend
# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# Disable CTRL-s and CTRL-q.
[[ $- =~ i ]] && stty -ixoff -ixon
# Make less more friendly for non-text input files, see lesspipe(1).
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

[ -r /usr/local/etc/profile.d/bash_completion.sh ] && source /usr/local/etc/profile.d/bash_completion.sh

# Set window title to PWD and last command
# Based on: https://arbtt.nomeata.de/doc/users_guide/effective-use.html
trap 'echo -ne "\033]2;$(pwd); $(history 1 | sed "s/^[ ]*[0-9]*[ ]*[0-9\/]*[ ]*[0-9\:]*[ ]*//g")\007"' DEBUG


# Environment variables
# --------------------------------------------------------------------

# History (man bash for help)
# Don't save duplicates, only save latest.
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
[ -z "$TMPDIR" ] && TMPDIR=/tmp

export EDITOR=vim
export VISUAL=vim

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export LSCOLORS=ExGxcxdxCxegedabagacad

# Aliases
# --------------------------------------------------------------------

alias grep='grep --color'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias l='ls -alF'
alias ll='ls -l'
alias vi='vim'
alias vim='vim'
alias which='type -p'
alias k5='kill -9 %%'

if [ "$PLATFORM" = Darwin ]; then
    o() {
        open --reveal "${1:-.}"
    }
fi

alias tmux='tmux -2'

if [ "$PLATFORM" = Darwin ]; then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi

alias venv='source .venv/bin/activate'

# Git
# Force include git bash completions else we don't have access to __git_* commands
# until after the first time we trigger auto complete, e.g., git <TAB><TAB>
[ -f /usr/share/bash-completion/completions/git ] && . /usr/share/bash-completion/completions/git

# Newer git versions allow git --list-cmds=alias, but to be backward compatible...
aliases=`git config --get-regexp alias | sed -E 's/alias.([a-z]+) .*$/\1/g'`
for al in $aliases; do
    alias g$al="git $al"

    complete_func=_git_$(__git_aliased_command $al)
    function_exists $complete_fnc && __git_complete g$al $complete_func
done

# Dotfiles
alias brc='vim ~/.bashrc'
alias vrc='vim ~/.vimrc'
alias trc='vim ~/.tmux.conf'
alias krc='vim ~/.config/karabiner.edn'

# Lisp
alias ccl='rlwrap ccl64'


# Prompt
# --------------------------------------------------------------------

# Super useful colors resource: https://misc.flogisoft.com/bash/tip_colors_and_formatting

__git_ps1() { :;}
[ -e ~/.git-prompt.sh ] && source ~/.git-prompt.sh
PS1=""
if [[ -n $SSH_CLIENT ]]; then
  PS1+="\[\e[32;1m\]"
  PS1+="\u@\h"
  PS1+="\[\e[0m\]"
  PS1+=" "
fi
PS1+="\[\e[34;1m\]"
PS1+="\w"
PS1+="\[\e[0m\]"
PS1+="\[\e[90;1m\]"
PS1+='$(__git_ps1)'
PS1+="\[\e[0m\]"
PS1+="\[\e[31;1m\]"
PS1+="\[\e[0m\]"
PS1+="\n\$ "


# FZF
# --------------------------------------------------------------------

export FZF_DEFAULT_OPTS='--color "preview-bg:237"'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"
if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'
fi
command -v bat  > /dev/null && export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
command -v blsd > /dev/null && export FZF_ALT_C_COMMAND='blsd'
command -v tree > /dev/null && export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# Journal
# --------------------------------------------------------------------

export JOURNAL_DIR=~/gdrive/journal

# Open today's journal entry.
function journal_today() {
    date=$(date +'%Y-%m-%d')
    file=$JOURNAL_DIR/$date.md
    if ! test -f $file; then
        printf "# $date\n\n" > $file
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


# Misc
# --------------------------------------------------------------------
[ -r $HOME/google-cloud-sdk/path.bash.inc ] && source $HOME/google-cloud-sdk/path.bash.inc
[ -r $HOME/google-cloud-sdk/completion.bash.inc ] && source $HOME/google-cloud-sdk/completion.bash.inc
[ -r /usr/local/opt/sqlite/bin/sqlite3 ] && export PATH=/usr/local/opt/sqlite/bin:$PATH
[ -f /usr/local/etc/profile.d/autojump.sh ] && source /usr/local/etc/profile.d/autojump.sh
[ -r /usr/local/opt/ruby/bin/ruby ] && export PATH=/usr/local/opt/ruby/bin:$PATH
