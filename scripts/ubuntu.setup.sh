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

DEBUG=true

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

debug_print() {
    echo -e "${cClear}[${cWhiteBrightBold} CMD ${cClear}]: ${cWhiteBright}$@${cClear}"
}

print_subject() {
    local topic=$1;
    local message=$2;
    echo -e "${cClear}[ ${cYellowBright}${topic}${cClear} ]: ${cGreen}${message}${cBlueBright}"
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

install_package "mc htop tree xclip lm-sensors net-tools unzip zip"
install_package "git wget curl gpg"
install_package "gnome-tweaks" # [?] dconf-editor
install_package "vlc ffmpeg"

install_vagrant

echo -e "[ ${cGreenBold}DONE${cClear} ]"
echo ""
