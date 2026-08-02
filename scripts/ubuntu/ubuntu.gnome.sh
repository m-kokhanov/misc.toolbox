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
    local key="${2:-}"
    local value="${3:-}"

    local current=$( gsettings get "${schema}" "${key}" )

    echo -e "  ${cYellowBright}${schema}${cClear} ${cYellowBrightBold}${key} ${cGreen}${current}${cClear}"

    if [[ true = "$DEBUG" ]]; then
        print_debug "" "  gsettings set $schema $key ${value}"
    else
        gsettings set ${schema} ${key} "${value}"
    fi
}

# -----------------------------------------------------------------------------

echo ""
print_warn "GNOME & TWEAKS" "Setup..."
echo ""

# dock

print_info "INFO" "Dock"
echo ""

g_configure org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36
g_configure org.gnome.shell.extensions.dash-to-dock dock-position "'LEFT'"
g_configure org.gnome.shell.extensions.dash-to-dock show-show-apps-button true
g_configure org.gnome.shell.extensions.dash-to-dock show-trash true

g_configure org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted true
g_configure org.gnome.shell.extensions.dash-to-dock show-mounts-network true

g_configure org.gnome.shell.extensions.dash-to-dock isolate-monitors false
g_configure org.gnome.shell.extensions.dash-to-dock isolate-workspaces true

echo ""

# window management

print_info "INFO" "Window management"
echo ""

g_configure org.gnome.mutter center-new-windows true

echo ""

# desktop / workspaces

print_info "INFO" "Desktop & Workspaces"
echo ""

g_configure org.gnome.mutter dynamic-workspaces false
g_configure org.gnome.mutter workspaces-only-on-primary false
g_configure org.gnome.desktop.wm.preferences num-workspaces 5

echo ""

# nautilus (file explorer)

print_info "INFO" "Nautilus ( Files )"
echo ""

g_configure org.gnome.nautilus.preferences show-hidden-files true
g_configure org.gnome.nautilus.preferences show-delete-permanently true
g_configure org.gnome.nautilus.preferences default-folder-viewer 'list-view'

echo ""

# keyboard

print_info "INFO" "Keyboard"
echo ""

g_configure org.gnome.desktop.peripherals.keyboard delay "uint32 340"
g_configure org.gnome.desktop.peripherals.keyboard repeat-interval "uint32 20"

echo ""

# update notifications

print_info "INFO" "Update nitifications"
echo ""

g_configure com.ubuntu.update-notifier no-show-notifications true
g_configure com.ubuntu.update-notifier regular-auto-launch-interval 90

echo ""

# -----------------------------------------------------------------------------

print_success "DONE" "Finished..."
echo ""

# -----------------------------------------------------------------------------

exit 0
