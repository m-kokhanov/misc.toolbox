#!/usr/bin/env bash

# -----------------------------------------------------------------------------

set -euo pipefail

# -----------------------------------------------------------------------------

DEBUG=${DEBUG:-false}

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

echo ""
print_warn "MACOS" "Setup..."
echo ""

# -----------------------------------------------------------------------------
# KEYBOARD & TRACKPAD
# -----------------------------------------------------------------------------

print_info "INFO" "Keyboard & Trackpad"
echo ""

# -g and NSGlobalDomain - are interchangable
g_configure -g InitialKeyRepeat -int 15
g_configure -g KeyRepeat -int 2

killall cfprefsd 2>/dev/null || true

echo ""

# -----------------------------------------------------------------------------
# Finder
# -----------------------------------------------------------------------------

print_info "INFO" "Finder.."

# Show hidden files
g_configure com.apple.finder AppleShowAllFiles -bool true

# Keep folders at the top when sorting by name
g_configure com.apple.finder _FXSortFoldersFirst -bool true

# Show all filename extensions (redundant but harmless if already set)
g_configure NSGlobalDomain AppleShowAllExtensions -bool true

# Show the path bar (bottom of Finder window)
g_configure com.apple.finder ShowPathbar -bool true

# Show the status bar (bottom of Finder window)
# Displays item count, available disk space, etc.
g_configure com.apple.finder ShowStatusBar -bool true

# Global
g_configure NSGlobalDomain AppleShowAllExtensions -bool true

# Keep folders at the top when sorting by name
g_configure com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default instead of the entire Mac
# g_configure com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable warning when changing a file extension
g_configure com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show external disks on the desktop
# g_configure com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

# Show removable media on the desktop (USB drives, SD cards)
# g_configure com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Show connected servers on the desktop
# g_configure com.apple.finder ShowMountedServersOnDesktop -bool true

# Restart Finder to apply changes
killall Finder 2>/dev/null || true

echo ""

# -----------------------------------------------------------------------------
# enable DOCK auto-hide, and set the animations to minimal values
# -----------------------------------------------------------------------------

print_info "INFO" "Dock auto-hide, short delay ..."
echo ""

g_configure com.apple.dock autohide -bool true
g_configure com.apple.dock autohide-delay -float 0.01
g_configure com.apple.dock autohide-time-modifier -float 0.12

echo ""

# -----------------------------------------------------------------------------

print_info "INFO" "Window minify effect ..."
echo ""

# window hide effect - "scale"
g_configure com.apple.dock mineffect -string scale

echo ""

# -----------------------------------------------------------------------------

print_info "INFO" "Expose ..."
echo ""

# duration of desktop switching animation reduction
# g_configure com.apple.dock expose-animation-duration -float 0.1
g_configure com.apple.dock expose-animation-duration -float 0.05

killall Dock 2>/dev/null || true

echo ""

# -----------------------------------------------------------------------------

exit 0
