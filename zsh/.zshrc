# Source modular config files
source ~/.zsh/00-environment.zsh
source ~/.zsh/01-history.zsh
source ~/.zsh/02-keybindings.zsh
source ~/.zsh/03-aliases.zsh
source ~/.zsh/04-git.zsh
source ~/.zsh/05-fzf.zsh

# Zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit light hlissner/zsh-autopair
zinit light MichaelAquilina/zsh-you-should-use
zinit light wfxr/forgit

# Completions
zstyle ':completion:*' menu select
autoload -Uz compinit && compinit

# Disable ctrl-s/ctrl-q
stty -ixon

# Atuin (better shell history)
eval "$(atuin init zsh)"

# Direnv (auto-load .envrc)
eval "$(direnv hook zsh)"

# Work config
[ -f "$HOME/.workrc" ] && source "$HOME/.workrc"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Zoxide (smarter cd) - must be at the end to prevent hook conflicts
eval "$(zoxide init zsh)"
