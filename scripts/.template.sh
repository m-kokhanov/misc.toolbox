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

cBlackBold="\033[1;38m"
cBlack="\033[38m"
cBlackBrightBold="\033[1;98m"
cBlackBright="\033[98m"

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

echo ""
print_info "INFO" "Message ..."
print_warn "WARN" "Warning message..."
print_error "FAIL" "Something failed... "
print_success "DONE" "Finished processing..."
echo ""

# -----------------------------------------------------------------------------
