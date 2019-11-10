# TODO: Remove all plugins...
# TODO: Custom prompt...
source ~/.zsh/00-environment.zsh
source ~/.zsh/01-history.zsh
source ~/.zsh/02-keybindings.zsh
source ~/.zsh/03-aliases.zsh

source ~/.zplug/init.zsh

# TODO: Decide whether to keep this simpler prompt over pure prompt
PROMPT="%F{green}%B%n@%m%f:%F{blue}%~%f%b$ "

# zplug "mafredri/zsh-async"
# zplug "sindresorhus/pure", use:pure.zsh, as:theme
zplug "zsh-users/zsh-autosuggestions", use:zsh-autosuggestions.zsh
zplug "zsh-users/zsh-history-substring-search", use:zsh-history-substring-search.zsh
zplug "plugins/osx", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh

# Use menu-styled completion
zstyle ':completion:*' menu select

# Source plugins and add commands to $PATH
zplug load

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

export PATH="/usr/local/opt/sqlite/bin:$PATH"

# Sqlite
alias sqlite="sqlite3 -column -header"

# Disables flow control (I think?) so we can use ctrl-s to forward search.
stty stop undef

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/seem/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/seem/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/seem/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/seem/google-cloud-sdk/completion.zsh.inc'; fi

