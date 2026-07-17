#!/usr/bin/env bash

# -----------------------------------------------------------------------------

print_message() {
    echo -e "$@"
}

print_success() {
    local topic="${1:-}"
    local message="${2:-}"

    local SUMMARY="${cClear}[${cGreenBrightBold} ${topic} ${cClear}]"
    local MSG="${cGreenBright}${message}${cClear}"

    if [ "" == "$topic" ]; then
        print_message "$MSG"
        return
    fi

    print_message "$SUMMARY" "$MSG"
}

print_error() {
    local topic="${1:-}"
    local message="${2:-}"

    local SUMMARY="${cClear}[${cRedBrightBold} ${topic} ${cClear}]"
    local MSG="${cRedBright}${message}${cClear}"

    if [ "" == "$1" ]; then
        print_message "$MSG"
        return
    fi

    print_message "$SUMMARY" "$MSG"
}

print_warn() {
    local topic="${1:-}"
    local message="${2:-}"

    local SUMMARY="${cClear}[${cYellowBrightBold} ${topic} ${cClear}]"
    local MSG="${cYellowBright}${message}${cClear}"

    if [ "" == "$1" ]; then
        print_message "$MSG"
        return
    fi

    print_message "$SUMMARY" "$MSG"
}

print_info() {
    local topic="${1:-}"
    local message="${2:-}"

    local SUMMARY="${cClear}[${cWhiteBrightBold} ${topic} ${cClear}]"
    local MSG="${cWhiteBright}${message}${cClear}"

    if [ "" == "$1" ]; then
        print_message "$MSG"
        return
    fi

    print_message "$SUMMARY" "$MSG"
}

print_debug() {
    local topic="${1:-}"
    local message="${2:-}"

    local SUMMARY="${cClear}[${cMagentaBrightBold} ${topic} ${cClear}]"
    local MSG="${cMagentaBright}${message}${cClear}"

    if [ "" == "$1" ]; then
        print_message "$MSG"
        return
    fi

    print_message "$SUMMARY" "$MSG"
}

# -----------------------------------------------------------------------------
