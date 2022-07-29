# launchd

## Jupyter Notebook

Run Jupyter Notebook as a service on macOS. If you'd like to repurpose this for your own use, **remember to replace the user name everywhere that `/Users/seem` appears**. Some properties worth noting:

- It's assumed that you're using [`pyenv`](https://github.com/pyenv/pyenv)
- `KeepAlive=true`: Jupyter Notebook will be restarted if it exits for any reason
- `WorkingDirectory` is set to home
- `stdout` and `stderr` are logged to `~/.jupyter/.jupyter.{stdout,stderr}`

### Setup

Copy the plist file to `LaunchAgents`:

```sh
cp local.jupyter.notebook.plist /Users/$USER/Library/LaunchAgents/
```

Start the service:

```sh
launchctl bootstrap gui/$(id -u $USER) /Users/$USER/Library/LaunchAgents/local.jupyter.notebook.plist
```

Print info to check that it's running (or to check the exit code if it failed):

```sh
launchctl print gui/$(id -u $USER)/local.jupyter.notebook.plist
```
