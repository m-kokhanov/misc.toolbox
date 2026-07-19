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

# archive.sh
# Create a ZIP archive without compression (-0)
# Works on macOS and Linux (requires `zip`)

usage() {
  echo "Usage:"
  echo "  $0 <target-file-or-folder> [output.zip]"
  exit 1
}

# --- Args ---
[[ $# -lt 1 || $# -gt 2 ]] && usage

TARGET="$1"
OUTPUT="${2:-}"

# --- Validate target ---
if [[ ! -e "$TARGET" ]]; then
  echo "Error: target does not exist: $TARGET"
  exit 1
fi

# Resolve absolute path
TARGET="$(cd "$(dirname "$TARGET")" && pwd)/$(basename "$TARGET")"

TARGET_DIR="$(dirname "$TARGET")"
TARGET_NAME="$(basename "$TARGET")"

# --- Default output name ---
if [[ -z "$OUTPUT" ]]; then
  OUTPUT="${TARGET}.zip"
fi

# Ensure output is absolute if relative path was provided
if [[ "$OUTPUT" != /* ]]; then
  OUTPUT="$(pwd)/$OUTPUT"
fi

# --- Exclude patterns ---
EXCLUDES=(
	"*.DS_Store"
	"*/.localized"
	"__MACOSX/*"
	".Spotlight-V100/*"
	".Trashes/*"
)

# --- Create archive ---
if [[ -d "$TARGET" ]]; then
  # Archive contents of directory, not directory itself
  (
    cd "$TARGET"

    zip -r -0 "$OUTPUT" . \
      $(printf -- " -x %q" "${EXCLUDES[@]}")
  )
else
  # Archive single file
  (
    cd "$TARGET_DIR"

    zip -0 "$OUTPUT" "$TARGET_NAME" \
      $(printf -- " -x %q" "${EXCLUDES[@]}")
  )
fi

echo ""
echo -e "${cYellowBrightBold}Created archive:${cClear}"
echo "  $OUTPUT"
echo ""

# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBrightBold}DONE${cClear} ]"
echo ""

# -----------------------------------------------------------------------------

exit 0
