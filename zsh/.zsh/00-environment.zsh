export PATH=/opt/local/bin:/opt/local/sbin:$PATH           # Macports
export PATH="/Library/TeX/texbin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"
export PATH="/usr/local/Cellar/pgcli/2.1.1_2/bin:$PATH"

export LANG=en_US.UTF-8

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

export EDITOR=vim
export VISUAL=vim

export LSCOLORS=ExGxcxdxCxegedabagacad

# See: https://superuser.com/questions/645599/why-is-a-percent-sign-appearing-before-each-prompt-on-zsh-in-windows
export PROMPT_EOL_MARK=""
