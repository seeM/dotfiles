# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# PATH additions
export PATH="$PATH:/Users/seem/dotfiles/bin"
export PATH="$PATH:/Users/seem/.local/bin"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="/usr/local/opt/coreutils/libexec/gnubin/":$PATH

# Java
export JAVA_HOME=/usr/local/opt/openjdk@11
export PATH="$JAVA_HOME/bin:$PATH"

# Google Cloud SDK
[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] && source "$HOME/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && source "$HOME/google-cloud-sdk/completion.zsh.inc"

# Work profile
[ -f "$HOME/.work_profile" ] && source "$HOME/.work_profile"

# Cargo
[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

# pnpm
export PNPM_HOME="/Users/seem/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
