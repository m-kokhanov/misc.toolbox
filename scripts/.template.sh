#!/usr/bin/env bash

# -----------------------------------------------------------------------------

set -euo pipefail

# -----------------------------------------------------------------------------

__WORKDIR="$( pwd )"
__SCRIPTDIR="$( cd -- "$( dirname -- "$( readlink -f -- "${BASH_SOURCE[0]}" )" )" && pwd )"

# -----------------------------------------------------------------------------

if [ -f "$__SCRIPTDIR/-colors.sh" ]; then
    . $__SCRIPTDIR/-colors.sh
fi

if [ -f "$__SCRIPTDIR/-messages.sh" ]; then
    . $__SCRIPTDIR/-messages.sh
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
