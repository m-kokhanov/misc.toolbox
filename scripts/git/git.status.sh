#!/usr/bin/env bash

set -euo pipefail

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

cBlackBold="\033[1;30m"
cBlack="\033[30m"
cBlackBrightBold="\033[1;90m"
cBlackBright="\033[90m"

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

# Ensure we're inside a Git repository.
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "[ ${cRedBrightBold}FAIL${cClear} ] ${cRed}Not inside a git repository${cClear}"
    echo ""
    exit 1
fi

# -----------------------------------------------------------------------------

usage() {
    cat <<EOF
Usage:
  $(basename "$0") <remote> [branch]

Examples:
  $(basename "$0") origin
  $(basename "$0") upstream
  $(basename "$0") origin main
EOF
}

# Check for arguments
if [[ $# -lt 1 || $# -gt 2 ]]; then
    usage
    exit 1
fi

# -----------------------------------------------------------------------------

remote="$1"

# -----------------------------------------------------------------------------

current_branch=$(git branch --show-current)

if [[ -z "$current_branch" ]]; then
    echo "fatal: HEAD is detached" >&2
    exit 1
fi

branch="${2:-$current_branch}"
target="$remote/$branch"

if ! git show-ref --verify --quiet "refs/remotes/$target"; then
    echo "fatal: remote branch '$target' does not exist" >&2
    exit 1
fi

# -----------------------------------------------------------------------------

read ahead behind < <(git rev-list --left-right --count HEAD..."$target")

# -----------------------------------------------------------------------------

echo -e "On branch ${cGreenBold}$current_branch${cClear}"

if (( ahead == 0 && behind == 0 )); then
    echo -e "Your branch is up to date with ${cGreenBold}'$target'${cClear}."
elif (( ahead > 0 && behind == 0 )); then
    plural=$([[ $ahead -eq 1 ]] && echo "" || echo "s")
    echo -e "Your branch is ahead of ${cYellowBrightBold}'$target'${cClear} by $ahead commit$plural."
    echo '  (use "git push" to publish your local commits)'
elif (( ahead == 0 && behind > 0 )); then
    plural=$([[ $behind -eq 1 ]] && echo "" || echo "s")
    echo -e "Your branch is behind ${cRedBold}'$target'${cClear} by $behind commit$plural."
    echo '  (use "git pull" to update your local branch)'
else
    echo -e "Your branch and ${cRedBrightBold}'$target'${cClear} have diverged,"
    echo "and have $ahead and $behind different commits each, respectively."
    echo '  (use "git pull" if you want to integrate the remote branch with yours)'
fi

# -----------------------------------------------------------------------------

exit 0
