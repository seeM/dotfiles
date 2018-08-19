source ~/.zplug/init.zsh

zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "zsh-users/zsh-autosuggestions", \
    use:zsh-autosuggestions/zsh-autosuggestions.zsh, \
    from:github

# Source plugins and add commands to $PATH
zplug load
