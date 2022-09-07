# Source: https://github.com/seem/dotfiles
# References:
# - https://github.com/junegunn/dotfiles

# System default
# --------------------------------------------------------------------

export PLATFORM=$(uname -s)
[ -s /etc/bashrc ] && . /etc/bashrc

# Trying to make git completion with aliases work on AWS ubuntu instances...
if ! shopt -oq posix; then
  if [ -s /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -s /etc/bash_completion ]; then
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
    declare -f -F "$1" > /dev/null
    return $?
}

[ -s /usr/local/etc/profile.d/bash_completion.sh ] && source /usr/local/etc/profile.d/bash_completion.sh


# Environment variables
# --------------------------------------------------------------------

# History (man bash for help)
# Don't save duplicates, only save latest.
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
[ -z "$TMPDIR" ] && TMPDIR=/tmp

export EDITOR=nvim
export VISUAL=nvim

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export LSCOLORS=ExGxcxdxCxegedabagacad

# Don't warn about zsh being the new default on MacOS
export BASH_SILENCE_DEPRECATION_WARNING=1

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Aliases
# --------------------------------------------------------------------

alias ql='qlmanage -p'
alias ocr='shortcuts run ocr'

alias notes='cd ~/Google\ Drive/My\ Drive/notes'
alias nbdev_switch='~/dotfiles/bin/nbdev_switch.js'
alias ns=nbdev_switch

alias grep='grep --color'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias which='type -p'
alias k5='kill -9 %%'

if [ "$PLATFORM" = Darwin ]; then
    o() {
        open --reveal "${1:-.}"
    }
fi

alias tmux='tmux -2'

alias batlog='bat --paging=never -l log'
alias cat=bat
alias ls=exa
alias ll='ls -la'
alias man=batman
alias vi=nvim
alias vim=nvim

alias ne=nbdev_export
alias nt=nbdev_test
alias nc=nbdev_clean
alias np=nbdev_prepare
alias nd=nbdev_docs
alias nr=nbdev_preview
alias nf=nbdev_fix

alias pi="pip install -e '.[dev]'"

alias co='cd ~/code/$(ls ~/code | fzf)'

get_venv_name() {
  basename "$PWD"
}

venv() {
  if [ ! -f .python-version ]; then
    pyenv virtualenv "$(get_venv_name)"
    pyenv local "$(get_venv_name)"
  fi
}

venv_delete() {
  if [ -f .python-version ]; then
    pyenv virtualenv-delete -f "$(get_venv_name)"
    rm .python-version
  fi
}

# Git
# Force include git bash completions else we don't have access to __git_* commands
# until after the first time we trigger auto complete, e.g., git <TAB><TAB>
[ -s /usr/share/bash-completion/completions/git ] && . /usr/share/bash-completion/completions/git


git_origin_or_fork() {
  if git remote 2>/dev/null | grep -iq seem; then
    echo "seem"
  else
    echo "origin"
  fi
}

alias g=git
alias glg='git log --pretty=format:"%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]" --decorate --date=short'

alias ga='git add'
alias gap='git add -p'
alias gc='git commit --verbose'
alias gcm='git commit -m'
alias gm='git commit --amend --verbose'

alias gd='git diff'
alias gdc='git diff --cached'

alias gcb='git rev-parse --abbrev-ref HEAD'
alias gp="git push \$(git_origin_or_fork) \$(gcb)"
alias gpf="gp -f"
alias gl="git pull \$(git_origin_or_fork) \$(gcb)"
alias glu="git pull upstream \$(gcb)"

alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'

alias gfo='git fetch origin master'
alias gro='git rebase origin/master'
alias gfogro='gfo && gro'
alias gupd='gfogro && gpf'

alias gb='git branch'
alias gs='git status --short --branch'
alias gco='git checkout'
alias gcob='git checkout -b'
# list branches sorted by last modified
# TODO: Temp disable because it's not working
# b = "!git for-each-ref --sort='-authordate' --format='%(authordate)%09%(objectname:short)%09%(refname)' refs/heads | sed -e 's-refs/heads/--'"

alias pr="gh pr create -f -b 'cc @hamelsmu @jph00'"
alias bug="pr -l 'bug'"
alias enhancement="pr -l 'enhancement'"
alias sync='gh repo sync seem/$(basename $(pwd)) && git pull && git fetch upstream'

alias squash='git rebase -i $(git merge-base HEAD master)'

# Dotfiles
alias brc='vim ~/.bashrc'
alias vrc='vim ~/.config/nvim'
alias trc='vim ~/.tmux.conf'
alias krc='vim ~/.config/karabiner.edn'

# Lisp
alias ccl='rlwrap ccl64'

# alias ro='repos open $(repos list | fzf)'
alias ro='python ~/code/alfred-repos/cli.py open $(python ~/code/alfred-repos/cli.py list | fzf)'
alias rv='open $(repo-links code)'
alias rc='open $(repo-links ci)'

# alias eo='
alias v='vim .'


# Prompt
# --------------------------------------------------------------------

# Super useful colors resource: https://misc.flogisoft.com/bash/tip_colors_and_formatting

__git_ps1() { :;}
[ -s /usr/local/etc/bash_completion.d/git-prompt.sh ] && source /usr/local/etc/bash_completion.d/git-prompt.sh
PS1=""
if [[ -n $SSH_CLIENT ]]; then
  PS1+="\[\e[32;1m\]"
  PS1+="\u@\h"
  PS1+="\[\e[0m\]"
  PS1+=" "
fi
PS1+="\[\e[34;1m\]"
PS1+="\w"
PS1+="\[\e[90;1m\]"
PS1+='$(__git_ps1)'
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
[ -s ~/.fzf.bash ] && source ~/.fzf.bash


# Misc
# --------------------------------------------------------------------
pyvim() { vim "$(python -c "import ${1} as o; print(o.__file__)")"; }
pyshow() { pygmentize "$(python -c "import ${1} as o; print(o.__file__)")"; }
[ -s ~/.cargo/env ] && source ~/.cargo/env

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
