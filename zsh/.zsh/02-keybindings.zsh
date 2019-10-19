# Keymaps

# Standard Mac bindings
# fn + left/right: beginning/end of line
# Can't use cmd + left/right because iterm uses that to switch tabs.
# TODO: Maybe remap iterm to something more vim like?
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
# option + left/right: next/previous word
bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word

# Fix delete button
bindkey "\e[3~" delete-char

# Replace up and down (typically previous and next commands in the history) with
# a more powerful search from the zsh-history-substring-search plugin.
# NOTE: Changed from ctrl to meta modifier so that it doesn't break readline
#       ctrl-p and ctrl-n behaviour.
bindkey '^[p' history-substring-search-up
bindkey '^[n' history-substring-search-down
# TODO: Trying to disable in favor of emacs (ctrl+p/n), will see if I miss it?
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down

# bindkey '^[p' up-line-or-search
# bindkey '^[n' down-line-or-search
