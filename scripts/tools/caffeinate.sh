#!/usr/bin/env bash

# -----------------------------------------------------------------------------

echo "Caffeinating..."

case $(uname -s) in
    Darwin)
        exec caffeinate -i
        ;;
    Linux)
        exec systemd-inhibit --what=idle:sleep sleep infinity
        ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac

# -----------------------------------------------------------------------------
