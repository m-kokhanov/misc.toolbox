#!/usr/bin/env bash

set -euo pipefail

extract() {
    local file="$1"

    [[ -f "$file" ]] || {
        echo "ERROR: File not found: $file" >&2
        return 1
    }

    case "${file,,}" in
        *.tar.gz|*.tgz)
            command -v tar >/dev/null || { echo "ERROR: tar not installed"; return 1; }
            tar -xzf "$file"
            ;;
        *.tar.bz2|*.tbz2)
            command -v tar >/dev/null || { echo "ERROR: tar not installed"; return 1; }
            tar -xjf "$file"
            ;;
        *.tar.xz|*.txz)
            command -v tar >/dev/null || { echo "ERROR: tar not installed"; return 1; }
            tar -xJf "$file"
            ;;
        *.tar)
            command -v tar >/dev/null || { echo "ERROR: tar not installed"; return 1; }
            tar -xf "$file"
            ;;
        *.zip)
            command -v unzip >/dev/null || { echo "ERROR: unzip not installed"; return 1; }
            unzip "$file"
            ;;
        *.gz)
            command -v gunzip >/dev/null || { echo "ERROR: gunzip not installed"; return 1; }
            gunzip -k "$file"   # keep original
            ;;
        *.bz2)
            command -v bunzip2 >/dev/null || { echo "ERROR: bunzip2 not installed"; return 1; }
            bunzip2 -k "$file"
            ;;
        *.xz)
            command -v unxz >/dev/null || { echo "ERROR: unxz not installed"; return 1; }
            unxz -k "$file"
            ;;
        *.7z)
            command -v 7z >/dev/null || { echo "ERROR: 7z not installed"; return 1; }
            7z x "$file"
            ;;
        *)
            echo "ERROR: Unsupported archive type: $file" >&2
            return 1
            ;;
    esac
}

extract "$1"
