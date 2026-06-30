#!/usr/bin/env bash

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

__WORKDIR=$( dirname $0 )

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

echo ""
print_info "INFO" "Tools"
echo ""

link_file "$HOME/projects/misc.tools/scripts/ubuntu/ubuntu.path.gitbranch" "$HOME/.bash_gitbranch"

link_file "$HOME/projects/misc.tools/scripts/tools/extract.sh" "$HOME/tools.extract.sh"
link_file "$HOME/projects/misc.tools/scripts/tools/move.sh" "$HOME/tools.move.sh"
link_file "$HOME/projects/misc.tools/scripts/tools/zip.archive.sh" "$HOME/tools.archive.sh"

# -----------------------------------------------------------------------------

echo ""
print_info "INFO" "Git"
echo ""

link_file "$HOME/projects/misc.tools/git/.gitconfig" "$HOME/.gitconfig"
link_file "$HOME/projects/misc.tools/scripts/git/git.setup.sh" "$HOME/tools.git-setup.sh"
link_file "$HOME/projects/misc.tools/scripts/git/git.fetch-all.sh" "$HOME/tools.git-fetch.sh"

link_file "$HOME/projects/misc.tools/scripts/git/git.fetch-all.sh" "$HOME/projects.repository/fetch-all.sh"

# -----------------------------------------------------------------------------

echo ""
print_success "DONE"
echo ""

# -----------------------------------------------------------------------------
