# dotfiles

## Installation

1. Manually configure [macOS settings](#macos-settings).
2. Clone and `cd` into this repo _with submodules_:

    ```bash
    $ git clone --recurse-submodules git@github.com:seem/dotfiles ~/dotfiles
    $ cd ~/dotfiles
    ```
3. Install [Homebrew](#homebrew).
4. Install from Brewfile with `brew bundle`:

    ```bash
    brew bundle install
    ```
5. Install [vim-plug](https://github.com/junegunn/vim-plug):

    ```bash
    $ stow ctags bash git karabiner tmux ipython vim
    ```
6. Install vim plugins:

    ```bash
    $ vim -c 'PlugUpdate | PlugInstall'
    ```
7. Manually install remaining [MacOS apps](#macos-apps).

## Font

Current: [SF Mono](https://developer.apple.com/fonts/)

Past: [IBM Plex Mono](https://github.com/IBM/plex)

## MacOS apps

_(Inspired by [Nikita Voloboev](https://github.com/nikitavoloboev/my-mac-os))_

### [1Password](https://1password.com/) - Password manager

### [Alfred](https://www.alfredapp.com/) - Launcher

### [Bear](https://bear.app/) - Writing

### [Firefox](https://www.mozilla.org/en-US/firefox/new/) - Browser

**Plugins:**

- Tridactyl
- TreeStyleTab
- Copy Selection as Markdown
- Some ad blocker

Add the lines below to the user stylesheet to disable the native tab bars, since we're using tree style tabs. The user stylesheet should be somewhere like `~/Library/Application Support/Firefox/Profiles/zh6rzv3s.default/chrome/userChrome.css`.

```css
/* Hide native tabs */
#TabsToolbar {visibility: collapse;}
```

### [Flux](https://justgetflux.com/) - Blue light controller

### [Keyboard Maestro](https://www.keyboardmaestro.com/main/) - Automation

### [GIMP-2.10](https://www.gimp.org/) - Image manipulation

### [Google Chrome](https://www.google.co.za/chrome/) - Browser

TODO: Plugins

### [Homebrew](https://brew.sh/) - Package manager

### [IINA](https://iina.io/) - Video player

### [Inkscape](https://inkscape.org/) - Vector graphics editor

```brew install inkscape```

### [iTerm](https://iterm2.com/) - Terminal emulator

### [Karabiner](https://pqrs.org/osx/karabiner/) - Keyboard remapping

The `~/.config/karabiner.edn` file is written in the Karabiner domain specific language [Goku](https://github.com/yqrashawn/GokuRakuJoudo).

Ensure that both Karabiner and Goku are installed, then `stow` the `karabiner` package.

### [LibreOffice](https://www.libreoffice.org/) - Office suite

### [Obsidian](https://obsidian.md/) - Writing

### [Rectangle](https://rectangleapp.com/) - Window manager

### [Spotify](https://www.spotify.com/us/) - Music

### [Things](https://culturedcode.com/things/) - Task manager

### [Transmission](https://www.transmissionbt.com/) - BitTorrent client

### [Zoom](https://zoom.us/) - Video calls

### [Zotero](https://www.zotero.org/) - Reference manager

## MacOS settings

### Dock

1. In the _Dock_ itself, remove all unneeded applications (probably everything except _Finder_, browser, terminal, notes).
2. Open _Dock_ settings.
3. Decrease _Size_ by eye.
4. Set _Position on screen_ to _Bottom_.
5. Check _Automatically hide and show the Dock_.
6. Uncheck _Show recent applications in Dock_.

### Finder

1. In _Finder_ itself, set to list view.
2. Open _Finder_ _Preferences_.
3. Set _New Finder windows show:_ to your home directory.
4. Uncheck _Open folders in tabs instead of new windows_.
5. Select _Tags_.
6. Uncheck all tags.
7. Select _Sidebar_.
8. Check your home directory.
9. Select _Advanced_.
10. Check _Show all filename extensions_.
11. Set _When performing a search_ to _Search the Current Folder_.

### Keyboard

1. Open _Keyboard_ settings.
2. Set _Key Repeat_ to fastest.
3. Set _Delay Until Repeat_ to fastest.
4. Check _Use F1, F2, etc. keys as standard function keys on external keyboards_.
5. Select _Text_ tab.
6. Remove _On my way!_ replacement.

### Mouse

1. Open _Mouse_ settings.
2. Set _Tracking speed_ to fifth from the right.
3. Open _Accessibility_ settings.
4. Select _Display_ on the left.
5. Select _Cursor_ tab.
6. Uncheck _Shake mouse pointer to locate_.

### Trackpad

1. Open _Trackpad_ settings.
2. Set _Click_ to _Light_.
3. Set _Tracking speed_ to fastest.
