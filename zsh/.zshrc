# TODO: Remove all plugins...
# TODO: Custom prompt...
# TODO: Join back into a single file...
source ~/.zsh/00-environment.zsh
source ~/.zsh/01-history.zsh
source ~/.zsh/02-keybindings.zsh
source ~/.zsh/03-aliases.zsh

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-autosuggestions", use:zsh-autosuggestions.zsh
zplug "zsh-users/zsh-history-substring-search", use:zsh-history-substring-search.zsh
zplug load

PROMPT="%F{green}%B%n@%m%f:%F{blue}%~%f%b$ "

FZF_DEFAULT_COMMAND='ag -l --hidden'

# zplug "zsh-users/zsh-autosuggestions", use:zsh-autosuggestions.zsh
# zplug "zsh-users/zsh-history-substring-search", use:zsh-history-substring-search.zsh

# Use menu-styled completion
zstyle ':completion:*' menu select

# Source plugins and add commands to $PATH
# zplug load

# autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Disables flow control (I think?) so we can use ctrl-s to forward search.
stty stop undef

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/seem/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/seem/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/seem/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/seem/google-cloud-sdk/completion.zsh.inc'; fi

export GREP_OPTIONS="--color"

# export WORDCHARS='*?[]~&;!$%^<>'
[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"
