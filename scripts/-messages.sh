#!/usr/bin/env bash

# -----------------------------------------------------------------------------

print_message() {
    echo -e "$@"
}

print_success() {
    local SUMMARY="${cClear}[${cGreenBrightBold} ${1} ${cClear}]"
    local MSG="${cGreenBright}${2}${cClear}"

    if [ "" == "$1" ]; then
        print_message "$MSG"
        return
    fi

    print_message "$SUMMARY" "$MSG"
}

print_error() {
    local SUMMARY="${cClear}[${cRedBrightBold} ${1} ${cClear}]"
    local MSG="${cRedBright}${2}${cClear}"

    if [ "" == "$1" ]; then
        print_message "$MSG"
        return
    fi

    print_message "$SUMMARY" "$MSG"
}

print_warn() {
    local SUMMARY="${cClear}[${cYellowBrightBold} ${1} ${cClear}]"
    local MSG="${cYellowBright}${2}${cClear}"

    if [ "" == "$1" ]; then
        print_message "$MSG"
        return
    fi

    print_message "$SUMMARY" "$MSG"
}

print_info() {
    local SUMMARY="${cClear}[${cWhiteBrightBold} ${1} ${cClear}]"
    local MSG="${cWhiteBright}${2}${cClear}"

    if [ "" == "$1" ]; then
        print_message "$MSG"
        return
    fi

    print_message "$SUMMARY" "$MSG"
}

print_debug() {
    local SUMMARY="${cClear}[${cMagentaBrightBold} ${1} ${cClear}]"
    local MSG="${cMagentaBright}${2}${cClear}"

    if [ "" == "$1" ]; then
        print_message "$MSG"
        return
    fi

    print_message "$SUMMARY" "$MSG"
}

# -----------------------------------------------------------------------------
