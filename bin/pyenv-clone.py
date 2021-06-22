#! /usr/bin/env python3
import argparse
import os
import re
import shutil
import subprocess
import sys
from typing import List

parser = argparse.ArgumentParser(
    description="Clone a git repo, create a virtualenv, and install."
)
parser.add_argument("url")
parser.add_argument("--force-virtualenv", action="store_true")
parser.add_argument("--remove-existing", action="store_true")
args = parser.parse_args()

errors: List[str] = []

match = re.match(r"git@(.*):(.*)/(.*)\.git", args.url)
if match is None:
    sys.exit(f"Error: Invalid URL: {args.url}")
remote_url, org, repo = match.groups()

if args.remove_existing:
    shutil.rmtree(repo, ignore_errors=True)

if not os.path.isdir(repo):
    subprocess.run(["git", "clone", args.url], check=True)

os.chdir(repo)

# Create the virtualenv and set it to local
a = ["pyenv", "virtualenv"]
if args.force_virtualenv:
    a.append("--force")
a.append(repo)
subprocess.run(a, check=True)
subprocess.run(["pyenv", "local", repo], check=True)

# Upgrade pip
subprocess.run(["pyenv", "exec", "pip", "install", "--upgrade", "pip"])

# Install lib in editable mode or app via requirements
files = os.listdir()
a = ["pyenv", "exec", "pip", "install"]
if "setup.py" in files or "pyproject.toml" in files:
    a.extend(["-e", "."])
else:
    requirements_file = next(f for f in files if "requirements" in f and f.endswith("txt"))
    a.extend(["-r", requirements_file])
subprocess.run(a, stderr=subprocess.PIPE)

# Install dev tools
dev_requirements = ["pynvim", "ipython", "ipdb", "flake8", "mypy", "black"]
subprocess.run(["pyenv", "exec", "pip", "install", *dev_requirements], check=True)
subprocess.run(["ctags"], check=True)
