#!/usr/bin/env bash

# -----------------------------------------------------------------------------

__WORKDIR="$( pwd )"
__SCRIPTDIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" && pwd )"

# -----------------------------------------------------------------------------

if [ -f "$__SCRIPTDIR/-colors.sh" ]; then
    . $__SCRIPTDIR/-colors.sh
fi

if [ -f "$__SCRIPTDIR/-messages.sh" ]; then
    . $__SCRIPTDIR/-messages.sh
fi

# -----------------------------------------------------------------------------

is_working_symlink() {
    [ -L "$1" ] && [ -e "$1" ]
}

link_file() {
    local src="$1"
    local dst="$2"

    if [ -L "$dst" ];
    then
        unlink "$dst"
    fi

    echo -e "  creating: ${cYellowBright}$( basename $dst )${cClear}"

    ln -s "$src" "$dst"
}

# -----------------------------------------------------------------------------

echo ""
print_warn "SETUP" "Initial setup..."

# -----------------------------------------------------------------------------

if [ "$(uname -s)" = "Linux" ]; then
    echo ""
    print_info "INFO" "Bash ( for Linux )"
    echo ""


    link_file "${__SCRIPTDIR}/ubuntu/ubuntu.bash.titlek" "$HOME/.bash_wintitle"
    link_file "${__SCRIPTDIR}/ubuntu/ubuntu.bash.gitbranch" "$HOME/.bash_gitbranch"
fi

# -----------------------------------------------------------------------------

echo ""
print_info "INFO" "Tools"
echo ""

link_file "${__SCRIPTDIR}/tools/extract.sh" "$HOME/tools.extract.sh"
link_file "${__SCRIPTDIR}/tools/move.sh" "$HOME/tools.move.sh"
link_file "${__SCRIPTDIR}/tools/zip.archive.sh" "$HOME/tools.archive.sh"

# -----------------------------------------------------------------------------

echo ""
print_info "INFO" "Git"
echo ""

link_file "${__SCRIPTDIR}/../git/.gitconfig" "$HOME/.gitconfig"

link_file "${__SCRIPTDIR}/git/git.status.sh" "$HOME/tools.git-status.sh"
link_file "${__SCRIPTDIR}/git/git.setup.sh" "$HOME/tools.git-setup.sh"
link_file "${__SCRIPTDIR}/git/git.fetch-all.sh" "$HOME/tools.git-fetch.sh"

echo ""

mkdir -p "$HOME/projects.repository" 2>/dev/null
link_file "${__SCRIPTDIR}/git/git.fetch-all.sh" "$HOME/projects.repository/fetch-all.sh"
echo -e "        at: $HOME/projects.repository"

# -----------------------------------------------------------------------------

echo ""
print_success "DONE"
echo ""

# -----------------------------------------------------------------------------
