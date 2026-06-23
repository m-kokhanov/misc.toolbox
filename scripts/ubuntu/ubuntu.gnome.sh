#!/usr/bin/env bash

# -----------------------------------------------------------------------------

cClear="\033[0m"

cRedBold="\033[1;31m"
cRed="\033[31m"
cRedBrightBold="\033[1;91m"
cRedBright="\033[91m"

cGreenBold="\033[1;32m"
cGreen="\033[32m"
cGreenBrightBold="\033[1;92m"
cGreenBright="\033[92m"

cYellowBold="\033[1;33m"
cYellow="\033[33m"
cYellowBrightBold="\033[1;93m"
cYellowBright="\033[93m"

cBlueBold="\033[1;34m"
cBlue="\033[34m"
cBlueBrightBold="\033[1;94m"
cBlueBright="\033[94m"

cMagentaBold="\033[1;35m"
cMagenta="\033[35m"
cMagentaBrightBold="\033[1;95m"
cMagentaBright="\033[95m"

cCyanBold="\033[1;36m"
cCyan="\033[36m"
cCyanBrightBold="\033[1;96m"
cCyanBright="\033[96m"

cWhiteBold="\033[1;37m"
cWhite="\033[37m"
cWhiteBrightBold="\033[1;97m"
cWhiteBright="\033[97m"

cBlackBold="\033[1;38m"
cBlack="\033[38m"
cBlackBrightBold="\033[1;98m"
cBlackBright="\033[98m"

# -----------------------------------------------------------------------------

print_success() {
    local SUMMARY="$1"
    local MSG="$2"

    echo -e "${cClear}[${cGreenBrightBold} ${SUMMARY} ${cClear}] ${cGreenBright}${MSG}${cClear}"
}

print_error() {
    local SUMMARY="$1"
    local MSG="$2"

    echo -e "${cClear}[${cRedBrightBold} ${SUMMARY} ${cClear}] ${cRedBright}${MSG}${cClear}"
}

print_warn() {
    local SUMMARY="$1"
    local MSG="$2"

    echo -e "${cClear}[${cYellowBrightBold} ${SUMMARY} ${cClear}] ${cYellowBright}${MSG}${cClear}"
}

print_info() {
    local SUMMARY="$1"
    local MSG="$2"

    echo -e "${cClear}[${cWhiteBold} ${SUMMARY} ${cClear}] ${cWhiteBright}${MSG}${cClear}"
}

# -----------------------------------------------------------------------------

gnome_configure() {
    local schema=$1
    local key=$2
    local value=$3

    local current=$( gsettings get "${schema}" "${key}" )

    echo -e "  ${cYellowBright}${schema}${cClear} ${cYellowBrightBold}${key} ${cGreen}${current}${cClear}"

    if [[ true = "$DEBUG" ]];
    then
        debug_print gsettings set $schema $key "${value}"
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

gnome_configure org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36
gnome_configure org.gnome.shell.extensions.dash-to-dock dock-position "'LEFT'"
gnome_configure org.gnome.shell.extensions.dash-to-dock show-show-apps-button true
gnome_configure org.gnome.shell.extensions.dash-to-dock show-trash true

gnome_configure org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted true
gnome_configure org.gnome.shell.extensions.dash-to-dock show-mounts-network true

gnome_configure org.gnome.shell.extensions.dash-to-dock isolate-monitors false
gnome_configure org.gnome.shell.extensions.dash-to-dock isolate-workspaces true

echo ""

# window management

print_info "INFO" "Window management"
echo ""

gnome_configure org.gnome.mutter center-new-windows true

echo ""

# desktop / workspaces

print_info "INFO" "Desktop & Workspaces"
echo ""

gnome_configure org.gnome.mutter dynamic-workspaces false
gnome_configure org.gnome.mutter workspaces-only-on-primary false
gnome_configure org.gnome.desktop.wm.preferences num-workspaces 5

echo ""

# nautilus (file explorer)

print_info "INFO" "Nautilus ( Files )"
echo ""

gnome_configure org.gnome.nautilus.preferences show-hidden-files true
gnome_configure org.gnome.nautilus.preferences show-delete-permanently true
gnome_configure org.gnome.nautilus.preferences default-folder-viewer 'list-view'

echo ""

# keyboard

print_info "INFO" "Keyboard"
echo ""

gnome_configure org.gnome.desktop.peripherals.keyboard delay "uint32 340"
gnome_configure org.gnome.desktop.peripherals.keyboard repeat-interval "uint32 20"

echo ""

# update notifications

print_info "INFO" "Update nitifications"
echo ""

gnome_configure com.ubuntu.update-notifier no-show-notifications true
gnome_configure com.ubuntu.update-notifier regular-auto-launch-interval 90

echo ""

# -----------------------------------------------------------------------------

print_success "DONE" "Finished..."
echo ""

# -----------------------------------------------------------------------------
