#!/usr/bin/env bash

# -----------------------------------------------------------------------------

set -euo pipefail

# -----------------------------------------------------------------------------

__WORK_DIR="$( pwd )"
__INVOCATION_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" && pwd )"
__SCRIPT_DIR="$( cd -- "$( dirname -- "$( readlink -f -- "${BASH_SOURCE[0]}" )" )" && pwd )"

# -----------------------------------------------------------------------------

if [ -f "$__SCRIPT_DIR/-colors.sh" ]; then
    . $__SCRIPT_DIR/-colors.sh
fi

if [ -f "$__SCRIPT_DIR/-messages.sh" ]; then
    . $__SCRIPT_DIR/-messages.sh
fi

# -----------------------------------------------------------------------------

SCRIPT_DIR="${SCRIPT_DIR:-${__SCRIPT_DIR}}"

# -----------------------------------------------------------------------------

is_working_symlink() {
    [ -L "$1" ] && [ -e "$1" ]
}

link_file() {
    local src="$1"
    local dst="$2"
    local is_sudo="${3:-}"

    if [ -L "$dst" ];
    then
        unlink "$dst"
    fi

    echo -e "  creating: ${cYellowBright}$( basename $dst )${cClear}"

    if [ "x-${is_sudo}" = "x-sudo" ]; then
        sudo ln -s "$src" "$dst"
    else
        ln -s "$src" "$dst"
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
print_warn "SETUP" "Initial setup..."

# -----------------------------------------------------------------------------

if [ "$(uname -s)" = "Linux" ]; then
    echo ""
    print_info "INFO" "Bash ( for Linux )"
    echo ""


    link_file "${SCRIPT_DIR}/ubuntu/ubuntu.bash.title" "$HOME/.bash_wintitle"
    link_file "${SCRIPT_DIR}/ubuntu/ubuntu.bash.gitbranch" "$HOME/.bash_gitbranch"
fi

# -----------------------------------------------------------------------------

echo ""
print_info "INFO" "Tools"
echo ""

link_file "${SCRIPT_DIR}/tools/extract.sh" "$HOME/tools.extract.sh"
link_file "${SCRIPT_DIR}/tools/extract.sh" "/usr/local/bin/extract" "sudo"

link_file "${SCRIPT_DIR}/tools/move.sh" "$HOME/tools.move.sh"
link_file "${SCRIPT_DIR}/tools/move.sh" "/usr/local/bin/move" "sudo"

link_file "${SCRIPT_DIR}/tools/zip.archive.sh" "$HOME/tools.archive.sh"
link_file "${SCRIPT_DIR}/tools/zip.archive.sh" "/usr/local/bin/archive" "sudo"

link_file "${SCRIPT_DIR}/tools/zip.archive.sh" "$HOME/tools.caffeinate.sh"
link_file "${SCRIPT_DIR}/tools/caffeinate.sh" "/usr/local/bin/keepalive" "sudo"

# -----------------------------------------------------------------------------

echo ""
print_info "INFO" "Git"
echo ""

link_file "${SCRIPT_DIR}/../git/.gitconfig" "$HOME/.gitconfig"

link_file "${SCRIPT_DIR}/git/git.status.sh" "$HOME/tools.git-status.sh"
link_file "${SCRIPT_DIR}/git/git.status.sh" "/usr/local/bin/git-status" "sudo"

link_file "${SCRIPT_DIR}/git/git.setup.sh" "$HOME/tools.git-setup.sh"
link_file "${SCRIPT_DIR}/git/git.setup.sh" "/usr/local/bin/git-setup" "sudo"

link_file "${SCRIPT_DIR}/git/git.fetch-all.sh" "$HOME/tools.git-fetch.sh"

echo ""

mkdir -p "$HOME/projects.repository" 2>/dev/null
link_file "${SCRIPT_DIR}/git/git.fetch-all.sh" "$HOME/projects.repository/fetch-all.sh"
echo -e "        at: $HOME/projects.repository"

# -----------------------------------------------------------------------------

echo ""
print_success "DONE"
echo ""

# -----------------------------------------------------------------------------

exit 0
