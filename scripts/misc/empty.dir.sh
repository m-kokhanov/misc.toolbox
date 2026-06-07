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

# -----------------------------------------------------------------------------

is_empty_dir() {
    [[ -d "$1" ]] &&
    [[ -z "$(find "$1" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]
}

# -----------------------------------------------------------------------------

check_directory() {
    if [ ! -d "$1" ]; then
        echo -e "[${cRedBrightBold} FAILED ${cClear}] ${cYellowBrightBold}${1}${cClear}. Not a directory"
        return 1
    fi

    if is_empty_dir "$1"; then
        echo -e "[${cGreenBrightBold} EMPTY ${cClear}] ${cGreenBright}$1${cClear}"
    else
        echo -e "[${cRedBrightBold} NOT EMPTY ${cClear}] ${cRedBright}$1${cClear}"
    fi
}

# -----------------------------------------------------------------------------

echo ""

check_directory "${HOME}/.BACKUP.TAKEOUT"
check_directory "${HOME}/projects"
check_directory "${HOME}/projects.repository"k

echo ""
check_directory "${HOME}/VirtualBox VMs"
echo ""

check_directory "${HOME}/Desktop"
check_directory "${HOME}/Documents"
check_directory "${HOME}/Downloads"
check_directory "${HOME}/Music"
check_directory "${HOME}/Pictures"
check_directory "${HOME}/Public"
check_directory "${HOME}/Templates"
check_directory "${HOME}/Videos"

echo ""
echo -e "[${cGreenBrightBold} DONE ${cClear}]"
echo ""

# -----------------------------------------------------------------------------

exit 1
