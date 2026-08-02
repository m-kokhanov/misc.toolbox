#!/usr/bin/env bash

# -----------------------------------------------------------------------------

set -euo pipefail

# -----------------------------------------------------------------------------

DEBUG=${DEBUG:-true}

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

print_subject() {
    local topic=$1;
    local message=$2;
    echo -e "${cClear}[ ${cYellowBright}${topic}${cClear} ]: ${cGreen}${message}${cBlueBright}"
}

# -----------------------------------------------------------------------------

update_package_metadata() {
    print_subject "UPDATING" "Packages metadata & database"

    if [[ true = "${DEBUG}" ]];
    then
        print_debug "DBG" "sudo apt update"
    else
        sudo apt update
    fi

    print_success "FINISHED"
    echo ""
}

# -----------------------------------------------------------------------------

install_package() {
    local _package=$1;

    print_subject "INSTALLING" "${_package}"

    if [[ true = "$DEBUG" ]];
    then
        print_debug "DBG" "sudo apt-get install y $_package"
    else
        sudo apt-get install -y $_package
    fi

    print_success "FINISHED"
    echo ""
}

# -----------------------------------------------------------------------------

install_vagrant() {
    # print_subject "PREPARING" "vagrant installation..."
    # wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    # echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

    install_package "vagrant"

    local result=$( vagrant -v >/dev/null )
    local res=$?

    if [[ 0 -ne $res ]];
    then
        print_error "FAILED" "{ $res }"
        echo ""
    fi
}

# -----------------------------------------------------------------------------

echo -e "${cBlackBright}This setup requires administrator privileges (sudo).${cClear}"

if ! sudo -v; then
    print_error "FAILURE" "Failed to obtain sudo access. Exiting..."
    exit 1
fi

# -----------------------------------------------------------------------------

echo ""
echo -e "[ ${cYellowBrightBold}UTILS & SOFTWARE${cClear} ] Installing..."
echo ""

# packages metadata & info
update_package_metadata

# utils
install_package "mc htop tree xclip lm-sensors net-tools unzip zip"
install_package "git wget curl gpg"

# apps
install_package "gnome-tweaks" # [?] dconf-editor
install_package "transmission vlc ffmpeg"

# tools
install_vagrant

# -----------------------------------------------------------------------------

print_success "DONE"
echo ""

# -----------------------------------------------------------------------------

exit 0
