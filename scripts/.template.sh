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

echo ""

print_info "INFO" "Message ..."
print_debug "DEBUG" "Message ..."
print_warn "WARN" "Warning message..."
print_error "FAIL" "Something failed... "
print_success "DONE" "Finished processing..."

echo ""

# -----------------------------------------------------------------------------

exit 0
