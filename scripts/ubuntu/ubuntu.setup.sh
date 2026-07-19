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

DEBUG=true

# -----------------------------------------------------------------------------

debug_print() {
    echo -e "${cClear}[${cWhiteBrightBold} CMD ${cClear}]: ${cWhiteBright}$@${cClear}"
}

print_subject() {
    local topic=$1;
    local message=$2;
    echo -e "${cClear}[ ${cYellowBright}${topic}${cClear} ]: ${cGreen}${message}${cBlueBright}"
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

install_vagrant() {
    [[ true = "${DEBUG}" ]] && return 0

    print_subject "PREPARING" "vagrant installation..."

    # wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    # echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    echo ""

    install_package "vagrant"

    local result=$( vagrant -v 2>&1 1>/dev/tty )

    if [ $? -ne 0 ]; then
        echo "${cRed}$result${cClear}"
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

# utils
install_package "mc htop tree xclip lm-sensors net-tools unzip zip"
install_package "git wget curl gpg"

# apps
install_package "gnome-tweaks" # [?] dconf-editor
install_package "transmission vlc ffmpeg"

# tools
install_vagrant

echo -e "[ ${cGreenBold}DONE${cClear} ]"
echo ""
