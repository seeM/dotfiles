# Keymaps
bindkey -e

# Standard Mac bindings
# fn + left/right: beginning/end of line
# Can't use cmd + left/right because iterm uses that to switch tabs.
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
# option + left/right: next/previous word
bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word

# Fix delete button
bindkey "\e[3~" delete-char

bindkey "^p" up-line-or-search
bindkey "^n" down-line-or-search
