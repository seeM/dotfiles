# `launchd`

Configuring background processes with `launchd`. See Apple's [_Daemons and Services Programming Guide_](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html) for more info.

## Jupyter Notebook

Run Jupyter Notebook as a service on macOS. If you'd like to repurpose this for your own use, **remember to replace with your user name everywhere that `/Users/seem` appears in `local.jupyter.notebook`**. Some properties worth noting:

- It's assumed that you're using [`pyenv`](https://github.com/pyenv/pyenv)
- `KeepAlive` is on; Jupyter Notebook will automatically restart after exiting
- `WorkingDirectory` is set to home
- `stdout` and `stderr` are logged to `~/.jupyter/jupyter.{stdout,stderr}`

### Setup

Copy the plist file to `LaunchAgents` (this is where `launchd` expects per-user processes to be defined):

```sh
cp local.jupyter.notebook.plist /Users/$USER/Library/LaunchAgents/
```

Start the process:

```sh
launchctl bootstrap gui/$(id -u $USER) /Users/$USER/Library/LaunchAgents/local.jupyter.notebook.plist
```

Print info to check that it's running (or to check the exit code if it failed):

```sh
launchctl print gui/$(id -u $USER)/local.jupyter.notebook.plist
```
