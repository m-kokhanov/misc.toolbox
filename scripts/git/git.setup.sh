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

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "[ ${cRedBrightBold}FAIL${cClear} ] ${cRed}Not inside a git repository${cClear}"
    echo ""
    exit 1
fi

# -----------------------------------------------------------------------------

AUTO_YES=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--yes)
            AUTO_YES=true
            shift
            ;;
        *)
            echo -e "[ ${cRedBrightBold}FAIL${cClear} ] ${cRed}Unknown option: $1${cClear}"
            exit 1
            ;;
    esac
done


# -----------------------------------------------------------------------------

UNAME=""
EMAIL=""

# -----------------------------------------------------------------------------

confirm() {
    local message="$1"

    if $AUTO_YES; then
        echo -e "$message ${cBlueBright}(auto-yes)${cClear}"
        return 0
    fi

    read -r -p "$message [y/N]: " reply

    [[ "$reply" =~ ^([yY]|yes|Yes|YES)$ ]]
}

# -----------------------------------------------------------------------------

# Detect if stdin has data
if [ -t 0 ]; then
    # Interactive mode
    read -r -p "Git user name: " UNAME
    read -r -p "Git user email: " EMAIL
else
    exec 3<&0
    exec </dev/tty

    # Read from stdin
    IFS= read -r UNAME <&3 || true
    IFS= read -r EMAIL <&3 || true
fi

# -----------------------------------------------------------------------------

# Validate input
if [[ -z "${UNAME}" || -z "${EMAIL}" ]]; then
    echo -e "[ ${cRedBrightBold}FAIL${cClear}] Name or email is empty"
    echo ""
    exit 1
fi

# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBrightBold}SETUP${cClear} ]: ${cGreenBright}Git repository configuration${cClear}"
echo "You're about to set local git configuration using:"
echo ""
echo -e "   user.name  = ${cYellowBrightBold}$UNAME${cClear}"
echo -e "   user.email = ${cYellowBrightBold}$EMAIL${cClear}"
echo ""

if ! confirm "Do you want to continue?"; then
    echo ""
    echo -e "[ ${cRedBrightBold}ABORTED${cClear} ] Cancelled by the user"
    echo ""
    exit 1
fi

# -----------------------------------------------------------------------------

# Apply git config (local only)
git config --local user.name "${UNAME}"
git config --local user.email "${EMAIL}"

# -----------------------------------------------------------------------------

echo ""
echo -e "[ ${cGreenBrightBold}DONE${cClear} ] ${cGreen}Local git config was updated successfully${cClear}"
echo ""

# -----------------------------------------------------------------------------

exit 0
