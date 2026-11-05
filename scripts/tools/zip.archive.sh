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
# Create a ZIP archive, stored without compression (-0) by default.
# Set COMPRESS=<0-9> to choose the compression level.
# Works on macOS and Linux (requires `zip`)

usage() {
  echo "Usage:"
  echo "  [COMPRESS=<0-9>] $0 <target-file-or-folder> [output.zip]"
  echo ""
  echo "Environment:"
  echo "  COMPRESS=<0-9>   compression level, passed to zip as -<level>"
  echo "                   0 = store only (default), 1 = fastest, 9 = best"
  exit 1
}

# --- Args ---
[[ $# -lt 1 || $# -gt 2 ]] && usage

TARGET="$1"
OUTPUT="${2:-}"

# --- Compression ---
COMPRESS="${COMPRESS:-0}"
if [[ ! "$COMPRESS" =~ ^[0-9]$ ]]; then
  echo "Error: COMPRESS must be a single digit 0-9, got: $COMPRESS"
  echo ""
  usage
fi
ZIP_LEVEL="-$COMPRESS"

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

    zip -r "$ZIP_LEVEL" "$OUTPUT" . \
      $(printf -- " -x %q" "${EXCLUDES[@]}")
  )
else
  # Archive single file
  (
    cd "$TARGET_DIR"

    zip "$ZIP_LEVEL" "$OUTPUT" "$TARGET_NAME" \
      $(printf -- " -x %q" "${EXCLUDES[@]}")
  )
fi

echo ""
echo -e "${cYellowBrightBold}Created archive:${cClear} (compression level: $COMPRESS)"
echo "  $OUTPUT"
echo ""

# -----------------------------------------------------------------------------

echo -e "[ ${cGreenBrightBold}DONE${cClear} ]"
echo ""

# -----------------------------------------------------------------------------

exit 0
