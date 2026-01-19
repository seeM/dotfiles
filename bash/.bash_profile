#!/usr/bin/env bash
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$PATH:/Users/seem/dotfiles/bin"
export PATH="$PATH:/Users/seem/.local/bin"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="/usr/local/opt/coreutils/libexec/gnubin/":$PATH

export JAVA_HOME=/usr/local/opt/openjdk@11
export PATH="$JAVA_HOME/bin:$PATH"

[ -f "$HOME/google-cloud-sdk/path.bash.inc" ] && source "$HOME/google-cloud-sdk/path.bash.inc" # updates $PATH
[ -f "$HOME/google-cloud-sdk/completion.bash.inc" ] && source "$HOME/google-cloud-sdk/completion.bash.inc" # enables shell completion

[ -f "$HOME/.work_profile" ] && source "$HOME/.work_profile"

. "$HOME/.cargo/env"

[ -s ~/.cargo/env ] && source ~/.cargo/env
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
. "$HOME/.cargo/env"

[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
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

