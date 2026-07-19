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

echo ""
echo -e "[ ${cYellowBrightBold}MESSAGES:${cClear} ]"
echo ""

print_success "DONE" "${cGreenBrightBold}Success message with custom color.."
print_success "DONE" "Success message.."
print_success "" "         Success message with no summary.."

echo ""

print_warn "WARN" "${cYellowBrightBold}Warning message with custom color.."
print_warn "WARN" "Warning message.."
print_warn "" "         Warning message with no summary.."

echo ""

print_info "INFO" "${cWhiteBrightBold}Information message with custom color.."
print_info "INFO" "Information message.."
print_info "" "         Information message with no summary.."

echo ""

print_debug " DBG" "${cMagentaBrightBold}Debug message with custom color.."
print_debug " DBG" "Debug message.."
print_debug "" "         Debug message with no summary.."

echo ""

print_error "FAIL" "${cRedBrightBold}Error message with custom color.."
print_error "FAIL" "Error message.."
print_error "" "         Error message with no summary.."

# -----------------------------------------------------------------------------

echo ""
echo -e "[ ${cGreenBrightBold}DONE${cClear} ]"
echo ""

# -----------------------------------------------------------------------------

exit 0
