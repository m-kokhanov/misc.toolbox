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

__WORKDIR="$( dirname "$0" )"
__FILTER="$1"

# -----------------------------------------------------------------------------

filter_by() {
    local needle="$1"
    local haystack="$(basename "$2" )"

    [[ -z "$needle" ]] && return 0

    # return the result of the last command
    [[ "${haystack}" == *"${needle}"* ]]
}

fetch_in() {
    ( cd "$1" && git fetch; )
}

fetch_in_folder() {
    local workdir="$1"
    local name=$( basename "$1" )

    echo -e "[ ${cGreenBrightBold}PROCESSING${cClear} ]: ${cGreenBrightBold}${name}${cClear}"
    echo -e "${cClear}  in: ${workdir}${cClear}"
    echo ""

    for f in "${workdir}/"*/;
    do
        filter_by "$__FILTER" "$f" || continue

        if [ -d "$f" ];
        then
            local dName=$( basename "$f" )
            echo -e "[ ${cYellowBright}FETCHING${cClear} ]: ${cYellowBrightBold}${dName}${cClear}"
            echo -e "${cClear}  in: ${f} ${cBlue}"

            fetch_in "$f"

            echo -e "${cClear}[ ${cGreen}FINISHED${cClear} ]"
            echo ""
        fi
    done
}

# -----------------------------------------------------------------------------

echo ""

fetch_in_folder "${__WORKDIR}"

# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBrightBold}DONE${cClear} ]"
echo ""
