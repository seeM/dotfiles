# Navigation
daily() {
  dir=~/daily/$(date +%Y/%m/%d)
  mkdir -p "$dir" && cd "$dir"
}

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias notes='cd ~/Google\ Drive/My\ Drive/notes'
alias co='cd ~/code/$(ls ~/code | fzf)'

# Files
alias ls='ls -G'
alias l='ls'
alias ll='ls -halG'

# Tools
alias grep='grep --color'
alias k5='kill -9 %%'
alias tmux='tmux -2'
command -v batman > /dev/null 2>&1 && alias man=batman
command -v nvim > /dev/null 2>&1 && alias vi=nvim && alias vim=nvim
alias batlog='bat --paging=never -l log'
alias cc='claude'

# Quick Look & macOS
alias ql='qlmanage -p'
alias ocr='shortcuts run ocr'
alias beep='afplay /System/Library/Sounds/Funk.aiff'

# nbdev
alias nbdev_switch='~/dotfiles/bin/nbdev_switch.js'
alias ns=nbdev_switch
alias ne=nbdev_export
alias nt=nbdev_test
alias nc=nbdev_clean
alias np=nbdev_prepare
alias nd=nbdev_docs
alias nr=nbdev_preview
alias nf=nbdev_fix
alias nu=nbdev_update

# Docker
alias dcd='docker compose down'
alias dcb='docker compose build'
alias dcu='docker compose up'
alias dcr='docker compose run'
alias dcp='docker compose ps'
alias dce='docker compose exec'
alias lzd='lazydocker'

# Quarto
alias qi='wget $(curl https://latest.fast.ai/pre/quarto-dev/quarto-cli/macos.pkg) && sudo installer -pkg quarto*.pkg -target / && rm quarto*.pkg'
alias qr='quarto preview'
alias qp='quarto publish'

# Python
alias pi="pip install -e '.[dev]'"
alias venv='source .venv/bin/activate'

# Dotfiles
alias brc='vim ~/.zshrc'
alias vrc='vim ~/.config/nvim'
alias zrc='vim ~/.zshrc'
alias trc='vim ~/.tmux.conf'
alias krc='vim ~/.config/karabiner.edn'

# Repos
alias ro='python ~/code/alfred-repos/cli.py open $(python ~/code/alfred-repos/cli.py list | fzf)'
alias rv='open $(repo-links code)'
alias rc='open $(repo-links ci)'

alias v='vim .'

# Tmux
function t() {
    if [[ $# -eq 0 ]]; then
        tmux attach-session 1>/dev/null 2>&1 || tmux new-session
    else
        tmux new-session -A -s $1
    fi
}
alias tl="tmux list-sessions"
function ta() {
    if [[ $# -eq 0 ]]; then
        tmux attach-session
    else
        tmux attach-session -t $1
    fi
}
alias tn="tmux new-session -s"
alias td="tmux detach-client"

# Misc functions
pyvim() { vim "$(python -c "import ${1} as o; print(o.__file__)")"; }
pyshow() { pygmentize "$(python -c "import ${1} as o; print(o.__file__)")"; }
