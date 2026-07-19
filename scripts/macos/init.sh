#!/usr/bin/env bash

# -----------------------------------------------------------------------------

set -euo pipefail

# -----------------------------------------------------------------------------

__WORKDIR="$( pwd )"
__SCRIPTDIR="$( cd -- "$( dirname -- "$( readlink -f -- "${BASH_SOURCE[0]}" )" )" && pwd )"

# -----------------------------------------------------------------------------

if [ -f "$__SCRIPTDIR/../-colors.sh" ]; then
    . $__SCRIPTDIR/../-colors.sh
fi

if [ -f "$__SCRIPTDIR/../-messages.sh" ]; then
    . $__SCRIPTDIR/../-messages.sh
fi

# -----------------------------------------------------------------------------
# KEYBOARD & TRACKPAD
# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBright}KEYBOARD${cClear} ] keypress delay & repeat";

defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

killall cfprefsd 2>/dev/null || true

# -----------------------------------------------------------------------------
# enable DOCK auto-hide, and set the animations to minimal values
# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBright}DOCK${cClear} ] auto-hide, short delay";

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0.01
defaults write com.apple.dock autohide-time-modifier -float 0.12

# window hide effect - "scale"
defaults write com.apple.dock mineffect -string scale

# duration of desktop switching animation reduction
# defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock expose-animation-duration -float 0.12

killall Dock 2>/dev/null || true

# -----------------------------------------------------------------------------
