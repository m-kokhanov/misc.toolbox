#!/usr/bin/env bash

# -----------------------------------------------------------------------------

set -euo pipefail

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

is_empty_dir() {
    [[ -d "$1" ]] &&
    [[ -z "$(find "$1" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]
}

# -----------------------------------------------------------------------------

check_directory() {
    local target="${1:-}"

    if [ ! -d "$target" ]; then
        echo -e "[${cRedBrightBold} FAILED ${cClear}] ${cYellowBrightBold}${1}${cClear}. Not a directory"
        return 0
    fi

    if is_empty_dir "$target"; then
        echo -e "[${cGreenBrightBold} EMPTY ${cClear}] ${cGreenBright}${target}${cClear}"
    else
        echo -e "[${cRedBrightBold} NOT EMPTY ${cClear}] ${cRedBright}${target}${cClear}"
    fi
}

# -----------------------------------------------------------------------------

echo ""

check_directory "${HOME}/BACKUP.TAKEOUT"
check_directory "${HOME}/projects"
check_directory "${HOME}/projects.repository"

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

exit 0
