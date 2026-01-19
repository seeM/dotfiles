# Git Functions
git_origin_or_fork() {
  if git remote 2>/dev/null | grep -iq seem; then
    echo "seem"
  else
    echo "origin"
  fi
}

git_current_branch() {
  git branch --show-current
}

git_default_branch() {
  basename "$(git symbolic-ref refs/remotes/origin/HEAD)"
}

git_has_upstream() {
  git remote | grep -qe upstream
}

synk() {
  default=$(git_default_branch)
  if [ "$(git_current_branch)" != "$default" ]; then
    echo 'ERROR: Not on main.'
    return 1
  fi
  if ! git_has_upstream; then
    echo 'ERROR: No upstream remote.'
    return 1
  fi
  if ! git diff --quiet; then
    echo 'ERROR: Unstaged changes.'
    return 1
  fi
  git fetch upstream "$default" &&
  git reset --hard "upstream/$default" &&
  git push --force origin "$default"
}

repo() {
  gh repo create "$1" --clone --description "$2" --homepage "seem.github.io/$1" --public --disable-wiki &&
  cd "$1" || return
}

git_clean() {
  git branch --merged | grep -E -v "(^\*|master|main|dev)" | xargs git branch -d
}

close() {
  current=$(git_current_branch)
  default=$(git_default_branch)
  if [ "$current" = "$default" ]; then
    echo "ERROR: Can't close main."
    return 1
  fi
  git checkout "$default" &&
  git pull || return 1
  if git_has_upstream; then
    synk || return 1
  fi
  git branch --delete "$current"
}

# macOS open
if [ "$PLATFORM" = Darwin ]; then
  o() {
    open --reveal "${1:-.}"
  }
fi

# Git Aliases
alias g=git
alias glg='git log --pretty=format:"%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]" --decorate --date=short'

alias ga='git add'
alias gap='git add -p'
alias gc='git commit --verbose'
alias gcm='git commit -m'
alias gm='git commit --amend --verbose'

alias gd='git diff'
alias gdc='git diff --cached'

alias gsu='git submodule update --recursive'

alias gcb='git rev-parse --abbrev-ref HEAD'
alias gp='git push $(git_origin_or_fork) $(git_current_branch)'
alias gpf='gp -f'
alias gl='git pull $(git_origin_or_fork) $(git_current_branch)'
alias glu='git pull upstream $(git_current_branch)'

alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'

alias gfo='git fetch origin master'
alias gro='git rebase origin/master'
alias gfogro='gfo && gro'
alias gupd='gfogro && gpf'

alias gb='git branch'
alias gs='git status --short --branch'
alias gco='git checkout'
alias gcob='git checkout -b'

alias pr='gh pr create --head seem:$(git_current_branch) --fill'
alias bug='pr --label "bug"'
alias enhancement='pr --label "enhancement"'
alias squash='git rebase -i $(git merge-base HEAD master)'
