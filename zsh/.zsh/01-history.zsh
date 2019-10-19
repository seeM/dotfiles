# History
HISTFILE=~/.zsh/history
HISTSIZE=10000
SAVEHIST=10000
# Append to history rather than rewrite.
setopt APPEND_HISTORY
# Save timestamp and duration.
setopt EXTENDED_HISTORY
# Import & export commands as they happen.
setopt SHARE_HISTORY
# Don't record duplicates from the same session.
setopt HIST_IGNORE_ALL_DUPS

