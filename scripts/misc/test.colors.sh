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

echo -e "[ ${cYellowBrightBold}COLORS$:${cClear} ]"
echo ""
echo -e "  - [${cGreenBrightBold} cGreenBrightBold ${cClear}]"
echo -e "  - [${cGreenBright} cGreenBright ${cClear}]"
echo -e "  - [${cGreenBold} cGreenBold ${cClear}]"
echo -e "  - [${cGreen} cGreen ${cClear}]"
echo ""
echo -e "  - [${cYellowBrightBold} cYellowBrightBold ${cClear}]"
echo -e "  - [${cYellowBright} cYellowBright ${cClear}]"
echo -e "  - [${cYellowBold} cYellowBold ${cClear}]"
echo -e "  - [${cYellow} cYellow ${cClear}]"
echo ""
echo -e "  - [${cRedBrightBold} cRedBrightBold ${cClear}]"
echo -e "  - [${cRedBright} cRedBright ${cClear}]"
echo -e "  - [${cRedBold} cRedBold ${cClear}]"
echo -e "  - [${cRed} cRed ${cClear}]"
echo ""
echo -e "  - [${cBlueBrightBold} cBlueBrightBold ${cClear}]"
echo -e "  - [${cBlueBright} cBlueBright ${cClear}]"
echo -e "  - [${cBlueBold} cBlueBold ${cClear}]"
echo -e "  - [${cBlue} cBlue ${cClear}]"
echo ""
echo -e "  - [${cMagentaBrightBold} cMagentaBrightBold ${cClear}]"
echo -e "  - [${cMagentaBright} cMagentaBright ${cClear}]"
echo -e "  - [${cMagentaBold} cMagentaBold ${cClear}]"
echo -e "  - [${cMagenta} cMagenta ${cClear}]"
echo ""
echo -e "  - [${cCyanBrightBold} cCyanBrightBold ${cClear}]"
echo -e "  - [${cCyanBright} cCyanBright ${cClear}]"
echo -e "  - [${cCyanBold} cCyanBold ${cClear}]"
echo -e "  - [${cCyan} cCyan ${cClear}]"
echo ""
echo -e "  - [${cWhiteBrightBold} cWhiteBrightBold ${cClear}]"
echo -e "  - [${cWhiteBright} cWhiteBright ${cClear}]"
echo -e "  - [${cWhiteBold} cWhiteBold ${cClear}]"
echo -e "  - [${cWhite} cWhite ${cClear}]"
echo ""
echo -e "  - [${cBlackBrightBold} cBlackBrightBold ${cClear}]"
echo -e "  - [${cBlackBright} cBlackBright ${cClear}]"
echo -e "  - [${cBlackBold} cBlackBold ${cClear}]"
echo -e "  - [${cBlack} cBlack ${cClear}]"
echo ""
echo -e "  - [${cClear} cClear ${cClear}]"
echo ""

# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBrightBold}DONE${cClear} ]"
echo ""

# -----------------------------------------------------------------------------

exit 0
