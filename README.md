# dotfiles

```bash
$ git clone --recurse-submodules git@github.com:seem/dotfiles ~/.dotfiles
$ cd ~/.dotfiles
$ stow vim tmux zsh    # for example
```

## Karabiner

The `~/.config/karabiner.edn` file is written in the Karabiner domain specific language [Goku](https://github.com/yqrashawn/GokuRakuJoudo).

Ensure that both Karabiner and Goku are installed, then `stow` the `karabiner` package.

```bash
$ brew cask install karabiner-elements
$ brew install yqrashawn/goku/goku
$ stow karabiner
```
