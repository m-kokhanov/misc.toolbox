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

install_package() {
    local _package=$1;

    echo -e "[ ${cYellowBright}INSTALLING${cClear} ]: ${cGreen}${_package}${cBlueBright}"

    sudo apt-get install -y $_package

    echo -e "${cClear}[ ${cGreen}FINISHED${cClear} ]"
    echo ""
}

# -----------------------------------------------------------------------------

echo -e "${cGrayBold}This setup requires administrator privileges (sudo).${cClear}"

if ! sudo -v; then
    echo -e "[ ${cRedBrightBold}FAILURE${cClear} ] ${cRedBright}Failed to obtain sudo access. Exiting.${cClear}"
    exit 1
fi

# -----------------------------------------------------------------------------

echo ""
echo -e "[ ${cYellowBrightBold}UTILS & SOFTWARE${cClear} ] Installing"
echo ""

install_package "mc htop tree xclip lm-sensors net-tools unzip zip"
install_package "git wget curl"
install_package "gnome-tweaks" # [?] dconf-editor
install_package "vlc ffmpeg"

echo -e "[ ${cGreenBold}DONE${cClear} ]"
echo ""

# -----------------------------------------------------------------------------
