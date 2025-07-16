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

# command -v bat > /dev/null 2>&1 && alias ls=bat
# command -v exa > /dev/null 2>&1 && alias ls=exa
command -v batman > /dev/null 2>&1 && alias man=batman
command -v nvim > /dev/null 2>&1 && alias vi=nvim && alias vim=nvim
alias batlog='bat --paging=never -l log'
alias ll='ls -la'

alias ne=nbdev_export
alias nt=nbdev_test
alias nc=nbdev_clean
alias np=nbdev_prepare
alias nd=nbdev_docs
alias nr=nbdev_preview
alias nf=nbdev_fix
alias nu=nbdev_update

alias dcd='docker compose down'
alias dcb='docker compose build'
alias dcu='docker compose up'
alias dcr='docker compose run'
alias dcp='docker compose ps'
alias dce='docker compose exec'

alias qi='wget $(curl https://latest.fast.ai/pre/quarto-dev/quarto-cli/macos.pkg) && sudo installer -pkg quarto*.pkg -target / && rm quarto*.pkg'
alias qr='quarto preview'
alias qp='quarto publish'

alias pi="pip install -e '.[dev]'"

alias co='cd ~/code/$(ls ~/code | fzf)'

get_venv_name() {
  basename "$PWD"
}

venv() {
  if [ ! -f .python-version ]; then
    pyenv virtualenv "$(get_venv_name)" &&
    pyenv local "$(get_venv_name)"
  fi
}

venv_delete() {
  if [ -f .python-version ]; then
    pyenv virtualenv-delete -f "$(get_venv_name)" &&
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

alias gsu='git submodule update --recursive'

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

git_current_branch() {
  git branch --show-current
}

git_default_branch() {
  basename "$(git symbolic-ref refs/remotes/origin/HEAD)"
}

git_has_upstream() {
  git remote | grep -qe upstream
}

synk() {
  # TODO: allow to run from another branch without affecting branch or unstaged changes
  default=$(git_default_branch)
  if [ "$(git_current_branch)" != "$default" ]; then
    echo 'ERROR: Not on main.'
    return 1
  fi
  if ! git_has_upstream; then
    echo 'ERROR: No upstream remote.'
    return 1
  fi
  if ! git diff --quiet; then
    # TODO: auto stash and unstash changes?
    echo 'ERROR: Unstaged changes.'
    return 1
  fi
  git fetch upstream "$default" &&
  git reset --hard "upstream/$default" &&
  git push --force origin "$default"
}

repo() {
  gh repo create "$1" --clone --description "$2" --homepage "seem.github.io/$1" --public --disable-wiki &&
  cd "$1" || return
}

git_clean() {
  git branch --merged | grep -E -v "(^\*|master|main|dev)" | xargs git branch -d
}

alias pr='gh pr create --head seem:$(git_current_branch) --fill'
alias bug="pr --label 'bug'"
alias enhancement="pr --label 'enhancement'"
alias squash='git rebase -i $(git merge-base HEAD master)'

close() {
  current=$(git_current_branch)
  if [ "$current" == "$default" ]; then
    echo "ERROR: Can't close main."
    return 1
  fi
  git checkout "$(git_default_branch)" &&
  git pull || return 1
  if git_has_upstream; then
    synk || return 1
  fi
  git branch --delete "$current"
}

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

# gc_user=jupyter
# gc_host=seem
# alias gc_start='gcloud compute instances start $gc_host'
# alias gc_stop="gcloud compute instances stop $gc_host"
# alias gc_ssh="gcloud compute ssh $gc_user@$gc_host"
# alias gc_lab="open https://$(gcloud notebooks instances describe seem --location us-west1-b --format="value(metadata.proxy-url)")/lab"

alias gradient_nbs='gradient notebooks list'

gradient_nb_id() {
  if [ -z "$1" ]; then
    echo 'ERROR: Missing positional argument NOTEBOOK'
    return 1
  fi
  gradient notebooks list | perl -F'/\s?\|\s?/' -E 'say $F[2] if $F[1] =~ '$1
}

gradient_nb() {
  if [ -z "$1" ]; then
    echo 'ERROR: Missing positional argument NOTEBOOK'
    return 1
  fi
  gradient notebooks details --id "$(gradient_nb_id "$1")"
}

gradient_nb_start() {
  typ=${2:-Free-P5000}
  gradient notebooks start --id "$(gradient_nb_id "$1")" --machineType "$typ" --shutdownTimeout 1
}

gradient_nb_stop() {
  gradient notebooks stop --id "$(gradient_nb_id "$1")"
}

gradient_nb_url() {
  gradient_nb "$1" | perl -F'/\s?\|\s?/' -E 'say $F[2] if $F[1] =~ FQDN'
}

gradient_nb_lab() {
  open "$(gradient_nb_url "$1")"/tree
}


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

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

[ -f "$HOME/.workrc" ] && source "$HOME/.workrc"

