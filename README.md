# dotfiles

## Contents

- [Installation](#installation)
- [MacOS apps](#macos-apps)
- [MacOS settings](#macos-settings)
- [Terminal apps](#terminal-apps)
- [How I use macOS](#how-i-use-macos)

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
5. Install vim plugins using [packer](https://github.com/wbthomason/packer.nvim):

    ```bash
    $ nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    ```
7. Manually install remaining [MacOS apps](#macos-apps).

## MacOS apps

### [1Password](https://1password.com/) - Password manager

### [Alacritty](https://github.com/alacritty/alacritty) - Terminal emulator

I used to use iTerm, but Alacritty feels more lightweight and better suited to how I use the terminal (with tmux).

### [Alfred](https://www.alfredapp.com/) - Launcher

Alfred's main advantage over the standard launcher is custom workflows.

#### Disable <kbd>ctrl</kbd> to _Show Actions_

Since I rebind <kbd>ctrl-p/n</kbd> to up/down using Karabiner, this option breaks browsing the search list.

Alfred Preferences → Features → Universal Actions → General → Show Actions (uncheck ctrl).

#### [`alfred-github-workflow`](https://github.com/gharlan/alfred-github-workflow)

#### [`alfred-emoji`](https://github.com/jsumners/alfred-emoji)

### [Flux](https://justgetflux.com/) - Blue light controller

### [GIMP-2.10](https://www.gimp.org/) - Image manipulation

### [Google Chrome](https://www.google.co.za/chrome/) - Browser

**Extensions:**

- 1Password
- Vimium (only occasionally use it)
- Twemex (Twitter sidebar)
- Some ad blocker

### [IINA](https://iina.io/) - Video player

### [Inkscape](https://inkscape.org/) - Vector graphics

Lots of confusing installation instructions out there, but `brew install inkspace` seems to work fine.

### [Karabiner](https://pqrs.org/osx/karabiner/) - Keyboard remapping

[`karabiner.edn`](./karabiner/.config/karabiner.edn) is written in the Karabiner domain specific language [Goku](#goku).

Ensure that both Karabiner and Goku are installed, then `stow` the `karabiner` package, and run `goku`.

### [Keyboard Maestro](https://www.keyboardmaestro.com/) – Mac automation

### [LibreOffice](https://www.libreoffice.org/) - Office suite

### [Obsidian](https://obsidian.md/) - Writing

### [Rectangle](https://rectangleapp.com/) - Window manager

### [Spotify](https://www.spotify.com/us/) - Music

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

### Language & Region

1. Open _Language & Region_ > _Advanced_ settings.
2. Set all cases of _Decimal_ to `.`.

## Terminal apps

See my [`Brewfile`](./Brewfile) for the full list of terminal applications I use. The most important ones are listed here.

### [Goku](https://github.com/yqrashawn/GokuRakuJoudo) - Simple Karabiner configuration

### [Homebrew](https://brew.sh/) - Package manager

### [Tmux](https://github.com/tmux/tmux) - Terminal window manager

### [NeoVIM](https://neovim.io/) - Text editor

## How I use macOS

### Window management with Rectangle

95% of the time I have a single application maximised with [Rectangle](https://github.com/rxhanson/Rectangle)–_not_ virtual desktops, I'll explain in a sec. I switch between applications using <kbd>cmd-tab</kbd> (or <kbd>cmd-\`</kbd> for different windows of the same application), Alfred (my preferred launcher, via <kbd>cmd-space</kbd>), or the dock when using my mouse. The other 15% of the time I have two windows open side-by-side. I resize the Dock to be quite small and set it to only show on hover so that I only see the application I'm using and the thin mac bar on the top (that can't be hidden last I checked).

I never use more than one virtual desktop. I find it inflexible and clunky in terms of both keyboard shortcuts and the animations that you can't seem to disable–for example, when fullscreening a window, or switching between fullscreened windows.

I instead use Rectangle to maximise windows in a single virtual desktop. You're supposed to be able to hold <kbd>option</kbd> and click on the green fullscreen button on the top-left of windows to do this, but I've found that it doesn't work properly for some applications. So I use [Rectangle](https://github.com/rxhanson/Rectangle) instead, which also has customiseable keyboard shortcuts. I only use these shortcuts:

- <kbd>control-option-enter</kbd>: Maximise
- <kbd>control-option-left</kbd>: Left Half
- <kbd>control-option-right</kbd>: Right Half

I find it convenient to use the same keys to move windows across screens (there's an option for this: _Preferences_ → _Move to adjacent display on repeated left or right commands_). I much less frequently use these too:

- <kbd>control-option-up</kbd>: Top Half
- <kbd>control-option-down</kbd>: Bottom Half

Rectangle also has a _Snap windows by dragging_ option, like Windows, which I like too.

### Mac oddities

Here are some behaviours I found very unexpected coming from Windows:

1. Some windows don't show up in <kbd>cmd-tab</kbd>, usually application settings. When that happens I use the "three finger drap up" gesture or <kbd>ctrl-up</kbd> to show all windows on my virtual desktop.
2. In mac, closing all windows of an application doesn't necessarily close the application. It still appears when you <kbd>cmd-tab</kbd> and in the dock. Use <kbd>cmd-q</kbd> to fully close an application. Caveat: for some reason you can't close the Finder application.
3. Finder's copy vs cut and paste is _very_ unintuitive. You first "select" a file with <kbd>cmd-c</kbd>, then use <kbd>cmd-v</kbd> to copy-paste, or <kbd>cmd-option-v</kbd> to cut-paste.

### Mac keyboard shortcuts

Mac applications often use the same standard keyboard shortcuts. Mac sometimes assumes that you know these, so doesn't make them clear. Here are the shortcuts I use:

- <kbd>cmd-<number></kbd>: Switch to a given tab. <kbd>cmd-9</kbd> switches to the *last* tab
- <kbd>cmd-{/}</kbd>: Left/right tab
- <kbd>cmd-t</kbd>: New tab
- <kbd>cmd-w</kbd>: Close a window in an application (or close a tab, depending on the application)
- <kbd>cmd-n</kbd>: New window (I rarely use multiple windows)
- <kbd>cmd-o</kbd>: Open file
- <kbd>cmd-s</kbd>: Save
- <kbd>cmd-q</kbd>: Close an application (and all of its windows)
- <kbd>touch id</kbd>: You can press the Touch ID button to lock your screen

I've setup tmux and Karabiner so that many of these work in the terminal too! I also have the following in my terminal:

- <kbd>cmd-h/j/k/l</kbd>: Left/down/up/right pane
- <kbd>cmd-h/j/k/l</kbd>: Left/down/up/right pane
- <kbd>cmd-d</kbd>: Split pane right (think "duplicate")
- <kbd>cmd-D</kbd>: Split pane down (think "duplicate")

### Alfred - Launching & switching applications

I use [Alfred](#alfred) instead of the defualt launcher. I don't use too many of its features or custom workflows anymore. It's also been a long time since I used the default launcher so I'm not even sure how much they differ anymore.

I mostly use Alfred by pressing <kbd>cmd-space</kbd> typing in a few characters to fuzzily search for the application I want to launch or switch to, and hitting <kbd>return</kbd>. After a while, you remember short letter combinations (usually two letters) needed for each application. For example, <kbd>cmd-space</kbd> <kbd>`ch`</kbd> <kbd>enter</kbd> switches to Chrome. Similarly, `al` for Alacritty (terminal), `ob` for Obsidian (notes), `di` for Discord, and so on.

It also has a built-in calculator which I find very convenient. You can type basic math directly into the search prompt and hit <kbd>enter</kbd> to paste the result into your clipboard.

The only custom workflow I use these days is for emojis, since not every application has a nice emoji auto-completer. I used to use a custom workflow that I wrote to open GitHub repos in my browser without needing any access to GitHub itself (via the git remote URL). I don't know why I stopped–it's very convenient!
