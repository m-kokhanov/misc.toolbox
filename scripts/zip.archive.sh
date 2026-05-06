#!/usr/bin/env bash

# -----------------------------------------------------------------------------

cClear="\033[0m"

cGreenBold="\033[1;32m"
cGreen="\033[32m"
cGreenBrightBold="\033[1;92m"
cGreenBright="\033[92m"

cYellowBold="\033[1;33m"
cYellow="\033[33m"
cYellowBrightBold="\033[1;93m"
cYellowBright="\033[93m"

cBlueBold="\033[1;34m"
cBlue="\033[34m"
cBlueBrightBold="\033[1;94m"
cBlueBright="\033[94m"

cRedBold="\033[1;31m"
cRed="\033[31m"
cRedBrightBold="\033[1;91m"
cRedBright="\033[91m"

# -----------------------------------------------------------------------------

set -euo pipefail

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

echo "Created archive:"
echo "  $OUTPUT"
