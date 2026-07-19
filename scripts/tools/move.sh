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

log() {
    echo -e "$@"
}

error() {
    echo -e "$@" >&2
}

usage() {
    echo ""
    echo -e "${cYellowBrightBold}Usage:${cClear}"
    echo ""
    echo "    ${0} <src> <dst>"
    echo ""
    echo -e "${cYellowBrightBold}Rules:${cClear}"
    echo ""
    echo "    - If <src> is a file:"
    echo "        * <dst> ending with "/" => treated as a directory"
    echo "        * otherwise => destination file path (rename allowed)"
    echo ""
    echo "    - If <src> is a directory:"
    echo "        * move contents of the directory (including hidden files)"
    echo "        * <dst> is always treated as directory"
    echo ""
    echo -e "${cYellowBrightBold}Examples:${cClear}"
    echo ""
    echo "    # move file inside {dst} directory"
    echo "    move.sh report.pdf /tmp/archive/"
    echo ""
    echo "    # move file & rename"
    echo "    move.sh report.pdf /tmp/archive/final-report.pdf"
    echo ""
    echo "    # move all files ( including hidden ) inside {dst} directory"
    echo "    move.sh project/ /tmp/archive/"
    echo ""
    echo "    # move all files ( including hidden ) inside {dst} directory"
    echo "    move.sh project/ /tmp/archive"
    echo ""

    exit 1
}

ensure_directory() {
    local dir="$1"

    if [[ ! -d "$dir" ]]; then
        log ""
        log "[ ${cYellowBrightBold}INFO${cClear} ] Target directory is missing..."
        log ""
        log "  Creating directory:"
        log "    $dir"

        mkdir -p "$dir"
    fi
}

move_file() {
    local src="$1"
    local dst="$2"

    if [[ "$dst" == */ ]]; then
        log "${cYellowBright}Source is a file${cClear}"
        log "${cYellowBright}Destination interpreted as a directory${cClear}"

        ensure_directory "$dst"

        log ""
        log "Moving:"
        log "  $src"
        log "  ->"
        log "  $dst"

        mv "$src" "$dst"
    else
        local parent
        parent="$(dirname "$dst")"

        ensure_directory "$parent"

        log "Source is a file"
        log "Destination interpreted as a file path"

        log ""
        log "Moving:"
        log "  $src"
        log "  ->"
        log "  $dst"

        mv "$src" "$dst"
    fi
}

move_directory_contents() {
    local src="$1"
    local dst="$2"

    log "Source is a directory"
    log "Destination interpreted as a directory"

    ensure_directory "$dst"

    shopt -s dotglob nullglob

    local items=("$src"/*)

    if (( ${#items[@]} == 0 )); then
        log "Directory is empty, nothing to move"

        shopt -u dotglob nullglob
        return 0
    fi

    log "Including hidden files and directories"

    mv "${items[@]}" "$dst/"

    shopt -u dotglob nullglob

    log "Moved ${#items[@]} item(s)"
}

main() {
    if [[ $# -ne 2 ]]; then
        usage
    fi

    local src="$1"
    local dst="$2"

    if [[ ! -e "$src" ]]; then
        error ""
        error "[ ${cRedBrightBold}ERROR${cClear} ]${cRedBright} Cannot find source:${cClear}"
        error "          ${cRedBright}$src${cClear}"
        error ""

        exit 1
    fi

    if [[ -f "$src" ]]; then
        move_file "$src" "$dst"
    elif [[ -d "$src" ]]; then
        move_directory_contents "$src" "$dst"
    else
        error "Unsupported source type: $src"

        exit 1
    fi
}

main "$@"

# -----------------------------------------------------------------------------

echo ""
echo -e "[ ${cGreenBrightBold}DONE${cClear} ]"
echo ""

# -----------------------------------------------------------------------------

exit 0
