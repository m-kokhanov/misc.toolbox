#!/usr/bin/env bash

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
