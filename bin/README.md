# `bin`

## `nbdev_switch` (experimental)

Jupyter Notebook file switching in the command line.

Add the script to a folder in your `PATH`, or alias it:

```sh
alias nbdev_switch='~/dotfiles/bin/nbdev_switch.js'
```

If you run it without commands, it'll open the current folder in Jupyter Notebook (it currently uses the URL and notebook directory of the first server returned by `jupyter notebook list`):

```sh
nbdev_switch
```

You can also open to a specific notebook:

```sh
nbdev_switch relative/path/to/notebook.ipynb
```

If a tab is already opened to the URL, it will be brought to the front.

### Technical notes

This is a Mac automation script written in JavaScript.
However, the only bit that really needs Mac automation is interacting with Chrome (the `openOrSwitchTab` function).
The rest could be rewritten in any language, and run `openOrSwitchTab` as an inline shell command.
