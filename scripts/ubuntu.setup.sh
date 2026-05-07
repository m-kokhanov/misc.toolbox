#!/usr/bin/env bash

# -----------------------------------------------------------------------------

cClear="\033[0m"

cGreenBold="\033[1;32m"
cGreen="\033[32m"
cGreenBrightBold="\033[1;92m"
cGreenBright="\033[92m"

cGrayBold="\033[1;38;5;250m"
cGray="\033[38;5;250m"

cYellowBold="\033[1;33m"
cYellow="\033[33m"
cYellowBrightBold="\033[1;93m"
cYellowBright="\033[93m"

cBlueBold="\033[1;34m"
cBlue="\033[34m"
cBlueBrightBold="\033[1;94m"
cBlueBright="\033[94m"

cRedBold="\033[1;31m"
cRed="\033[31m"
cRedBrightBold="\033[1;91m"
cRedBright="\033[91m"

# -----------------------------------------------------------------------------

DEBUG=false

debug_print() {
    echo -e "${cYellowBright}[ cmd ]: $@${cClear}"
}

print_subject() {
    local topic=$1;
    local message=$2;
    echo -e "${cClear}[ ${cYellowBright}${topic}${cClear} ]: ${cGreen}${message}${cBlueBright}"
}

print_success() {
    local summary=$1;
    echo -e "${cClear}[ ${cGreen}${summary}${cClear} ]"
    echo ""
}

print_failure() {
    local topic=$1
    local message=$2
    echo -e "[ ${cRedBrightBold}${topic}${cClear} ] ${cRedBright}${message}${cClear}"
}

# -----------------------------------------------------------------------------

install_package() {
    local _package=$1;

    print_subject "INSTALLING" "${_package}"

    if [[ true = "$DEBUG" ]];
    then
        debug_print sudo apt-get install y $_package
    else
        sudo apt-get install -y $_package
    fi

    print_success "FINISHED"
}

# -----------------------------------------------------------------------------

echo -e "${cGrayBold}This setup requires administrator privileges (sudo).${cClear}"

if ! sudo -v; then
    print_failure "FAILURE" "Failed to obtain sudo access. Exiting..."
    exit 1
fi

# -----------------------------------------------------------------------------

echo ""
echo -e "[ ${cYellowBrightBold}UTILS & SOFTWARE${cClear} ] Installing..."
echo ""

install_package "mc htop tree xclip lm-sensors net-tools unzip zip"
install_package "git wget curl"
install_package "gnome-tweaks" # [?] dconf-editor
install_package "vlc ffmpeg"

echo -e "[ ${cGreenBold}DONE${cClear} ]"
echo ""

# -----------------------------------------------------------------------------

gnome_configure() {
    local schema=$1
    local key=$2
    local value=$3

    local current=$( gsettings get "${schema}" "${key}" )

    echo -e "${cYellowBright}${schema}${cClear} ${cYellowBrightBold}${key} ${cGreen}${current}${cClear}"

    if [[ true = "$DEBUG" ]];
    then
        debug_print gsettings set $schema $key "${value}"
    else
        gsettings set ${schema} ${key} "${value}"
    fi
}

# -----------------------------------------------------------------------------

echo ""
echo -e "[ ${cYellowBrightBold}GNOME & TWEAKS${cClear} ] Setup..."
echo ""


# dock
gnome_configure org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gnome_configure org.gnome.shell.extensions.dash-to-dock dock-position "'LEFT'"
gnome_configure org.gnome.shell.extensions.dash-to-dock show-show-apps-button true
gnome_configure org.gnome.shell.extensions.dash-to-dock show-trash true

gnome_configure org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted true
gnome_configure org.gnome.shell.extensions.dash-to-dock show-mounts-network true

gnome_configure org.gnome.shell.extensions.dash-to-dock isolate-monitors false
gnome_configure org.gnome.shell.extensions.dash-to-dock isolate-workspaces true

echo ""

# window management
gnome_configure org.gnome.mutter center-new-windows true

echo ""

# desktop / workspaces
gnome_configure org.gnome.mutter dynamic-workspaces false
gnome_configure org.gnome.mutter workspaces-only-on-primary false
gnome_configure org.gnome.desktop.wm.preferences num-workspaces 5

echo ""

# keyboard
gnome_configure org.gnome.desktop.peripherals.keyboard delay "uint32 340"
gnome_configure org.gnome.desktop.peripherals.keyboard repeat-interval "uint32 20"

echo ""

# update notifications
gnome_configure com.ubuntu.update-notifier no-show-notifications true
gnome_configure com.ubuntu.update-notifier regular-auto-launch-interval 90

echo ""
echo -e "[ ${cGreenBold}DONE${cClear} ]"
echo ""

# -----------------------------------------------------------------------------
