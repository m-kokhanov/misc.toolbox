#!/usr/bin/env bash

# -----------------------------------------------------------------------------

set -euo pipefail

# -----------------------------------------------------------------------------

__WORK_DIR="$( pwd )"
__INVOCATION_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" && pwd )"
__SCRIPT_DIR="$( cd -- "$( dirname -- "$( readlink -f -- "${BASH_SOURCE[0]}" )" )" && pwd )"

# -----------------------------------------------------------------------------

if [ -f "$__SCRIPT_DIR/../-colors.sh" ]; then
    . $__SCRIPT_DIR/../-colors.sh
fi

if [ -f "$__SCRIPT_DIR/../-messages.sh" ]; then
    . $__SCRIPT_DIR/../-messages.sh
fi

# -----------------------------------------------------------------------------

DEBUG=true

# -----------------------------------------------------------------------------

g_configure() {
    local schema="${1:-""}"
    local key="${2:-""}"
    local type="${3:-""}"
    local value="${4:-""}"

    local current=$( defaults read "${schema}" "${key}" )

    echo -e "  ${cYellowBright}${schema}${cClear} ${cYellowBrightBold}${key} ${cGreen}${current}${cClear}"

    if [[ true = "$DEBUG" ]]; then
        print_debug "" "  defaults write $schema $key ${type} ${value}"
    else
        defaults write ${schema} ${key} ${type} "${value}"
    fi
}

# -----------------------------------------------------------------------------
# KEYBOARD & TRACKPAD
# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBright}KEYBOARD${cClear} ] keypress delay & repeat";

g_configure -g InitialKeyRepeat -int 15

# -g and NSGlobalDomain - are interchangable
g_configure -g InitialKeyRepeat -int 15
g_configure -g KeyRepeat -int 2

killall cfprefsd 2>/dev/null || true

# -----------------------------------------------------------------------------
# enable DOCK auto-hide, and set the animations to minimal values
# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBright}DOCK${cClear} ] auto-hide, short delay";

g_configure com.apple.dock autohide -bool true
g_configure com.apple.dock autohide-delay -float 0.01
g_configure com.apple.dock autohide-time-modifier -float 0.12

# window hide effect - "scale"
g_configure com.apple.dock mineffect -string scale

# duration of desktop switching animation reduction
# g_configure com.apple.dock expose-animation-duration -float 0.1
g_configure com.apple.dock expose-animation-duration -float 0.12

killall Dock 2>/dev/null || true

# -----------------------------------------------------------------------------

exit 0
