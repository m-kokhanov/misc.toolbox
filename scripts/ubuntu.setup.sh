#!/usr/bin/env bash

# -----------------------------------------------------------------------------

cClear="\033[0m"

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

cRedBold="\033[1;31m"
cRed="\033[31m"
cRedBrightBold="\033[1;91m"
cRedBright="\033[91m"

# -----------------------------------------------------------------------------

install_package() {
    _package="${1}";

    echo -e "[ ${cYellowBrightBold}INSTALLING${cClear} ]: ${cGreenBold}${_package}${cBlueBright}"

    apt-get install -y $_package

    echo -e "${cClear}[ ${cGreenBold}DONE${cClear} ]"
    echo ""
}

# -----------------------------------------------------------------------------

echo ""

install_package "mc htop xclip"
install_package "gnome-tweaks dconf-editor"
install_package "vlc"

# -----------------------------------------------------------------------------
