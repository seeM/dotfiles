#!/usr/bin/env bash
NM=$1

set -e pipefail

DOM=gui/$(id -u $USER)
SVC=$DOM/$NM
PLIST=/Users/$USER/Library/LaunchAgents/$NM.plist

sudo launchctl bootout $DOM $PLIST
sudo launchctl bootstrap $DOM $PLIST
sleep 0.2
sudo launchctl print $SVC
