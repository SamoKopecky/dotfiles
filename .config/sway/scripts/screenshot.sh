#!/usr/bin/env bash
# Region screenshot → satty editor → clipboard + file
set -euo pipefail

dir="$HOME/Pictures/screenshots"
mkdir -p "$dir"
out="$dir/satty-$(date '+%Y%m%d-%H%M%S').png"

geom="$(slurp -d)" || exit 0

grim -g "$geom" - | satty \
    --filename - \
    --output-filename "$out" \
    --early-exit \
    --copy-command wl-copy
