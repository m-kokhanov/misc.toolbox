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
