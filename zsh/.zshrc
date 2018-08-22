# Locale settings in pycharm don't seem to be set while settings in iTerm are
# correct. We explicitly set locale settings to make pycharm happy.
LC_ALL=en_us.UTF-8
LC_CTYPE=en_us.UTF-8
LANG=en_us.UTF-8

# Pyenv
PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

source ~/.zplug/init.zsh

zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "zsh-users/zsh-autosuggestions", \
    use:zsh-autosuggestions/zsh-autosuggestions.zsh, \
    from:github

# Source plugins and add commands to $PATH
zplug load
