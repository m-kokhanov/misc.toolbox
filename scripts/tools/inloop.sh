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

to_seconds() {
	local duration="$1"

	local unit="${duration: -1}"
	local value="${duration%?}"

	case "$unit" in
		s) duration=$(( value * 1 )) ;;
		m) duration=$(( value * 60 )) ;;
		h) duration=$(( value * 3600 )) ;;
	esac

	echo "${duration}s"
}

# -----------------------------------------------------------------------------

_DELAY="${1}"
_CYCLE=0

shift

# -----------------------------------------------------------------------------

print_info "INFO" "Using delay $( to_seconds "$_DELAY" ) executing: $@"

while true; do
	"$@"

	_CYCLE=$(( _CYCLE + 1 ))

	echo ""
	print_message "----------------------------------------------------------"
	print_warn "DONE" "Run: { $_CYCLE } finished..."
	print_warn "INFO" "Next run in "$_DELAY" ( $( to_seconds "$_DELAY" ) ) ..."
	echo ""

 	sleep "$( to_seconds "$_DELAY" )"
done
