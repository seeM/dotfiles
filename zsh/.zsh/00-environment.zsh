# Paths
# Macports
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# Language
export LANG=en_US.UTF-8

# Python
# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# Editors
export EDITOR=vim
export VISUAL=vim

export LSCOLORS=ExGxcxdxCxegedabagacad

# zsh
# See: https://superuser.com/questions/645599/why-is-a-percent-sign-appearing-before-each-prompt-on-zsh-in-windows
export PROMPT_EOL_MARK=""
