#!/usr/bin/env bash
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$PATH:/Users/seem/.local/bin"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="/usr/local/opt/coreutils/libexec/gnubin/":$PATH

export JAVA_HOME=/usr/local/opt/openjdk@11
export PATH="$JAVA_HOME/bin:$PATH"

# export PYENV_ROOT="$HOME/.pyenv"
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib -L/usr/local/opt/openssl@3/lib -L/usr/local/opt/lapack/lib"
# export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include -I/usr/local/opt/openssl@3/include -I/usr/local/opt/lapack/include"

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
