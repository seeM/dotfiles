# dotfiles

```bash
$ git clone --recurse-submodules git@github.com:seem/dotfiles ~/.dotfiles
$ cd ~/.dotfiles
$ stow vim tmux zsh    # for example
```

## vim

Install `vim-plug`:

```bash
$ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Install plugins:

```bash
$ vim -c 'PlugUpdate | PlugInstall'
```

## Karabiner

The `~/.config/karabiner.edn` file is written in the Karabiner domain specific language [Goku](https://github.com/yqrashawn/GokuRakuJoudo).

Ensure that both Karabiner and Goku are installed, then `stow` the `karabiner` package.

```bash
$ brew cask install karabiner-elements
$ brew install yqrashawn/goku/goku
$ stow karabiner
```

## Font

Current: [SF Mono](https://developer.apple.com/fonts/)

Past: [IBM Plex Mono](https://github.com/IBM/plex)

## Firefox

**Plugins:**

- Tridactyl
- TreeStyleTab
- OneTab
- Instapaper
- Copy Selection as Markdown
- Some ad blocker

Add the lines below to the user stylesheet to disable the native tab bars, since we're using tree style tabs. The user stylesheet should be somewhere like `~/Library/Application Support/Firefox/Profiles/zh6rzv3s.default/chrome/userChrome.css`.

```css
/* Hide native tabs */
#TabsToolbar {visibility: collapse;}
```
