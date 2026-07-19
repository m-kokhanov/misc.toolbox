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

__FILTER="${1:-}"

# allow to receive a variable from the ENV, or fallback to use the WORKDIR
PROJECTS_REPOSITORY="${PROJECTS_REPOSITORY:-${__WORKDIR}}"

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
    echo -e "${cClear}  in: ${cWhite}${workdir}/${cClear}"
    echo ""

    for f in "${workdir}"/*;
    do
        filter_by "$__FILTER" "$f" || continue

        if [ -d "$f" ];
        then
            local dName=$( basename "$f" )
            echo -e "[ ${cYellowBright}FETCHING${cClear} ]: ${cYellowBrightBold}${dName}${cClear}"
            echo -e "${cClear}  in: ${cWhite}${f}/${cBlue}"

            fetch_in "$f"

            echo -e "${cClear}[ ${cGreen}FINISHED${cClear} ]"
            echo ""
        fi
    done
}

# -----------------------------------------------------------------------------

echo ""

for f in "${PROJECTS_REPOSITORY}"/*; do
    [[ -d "$f" ]] || continue
    fetch_in_folder "$f"
done

# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBrightBold}DONE${cClear} ]"
echo ""
