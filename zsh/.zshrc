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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/seem/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/seem/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/seem/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/seem/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Keymaps
bindkey -v    # vim mode
export KEYTIMEOUT=1    # make vim mode transitions faster

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Fix backscape button in vi mode
bindkey "^?" backward-delete-char
# Fix delete button
bindkey "\e[3~" delete-char
bindkey -M vicmd "\e[3~" delete-char

# Fix history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
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
