#!/usr/bin/env bash
# Cycle X11 keyboard layouts. Edit LAYOUTS to add/remove.
# Format: "layout[:variant]" e.g. "us", "sk", "cz:qwerty", "de:nodeadkeys"

set -euo pipefail

LAYOUTS=("us" "sk")
XKB_OPTIONS="terminate:ctrl_alt_bksp"

current="$(setxkbmap -query | awk '/^layout:/  {print $2}' | cut -d, -f1)"
current_variant="$(setxkbmap -query | awk '/^variant:/ {print $2}' | cut -d, -f1)"
[[ -n "${current_variant:-}" ]] && current="${current}:${current_variant}"

next=""
for i in "${!LAYOUTS[@]}"; do
    if [[ "${LAYOUTS[$i]}" == "$current" ]]; then
        next="${LAYOUTS[$(( (i + 1) % ${#LAYOUTS[@]} ))]}"
        break
    fi
done
[[ -z "$next" ]] && next="${LAYOUTS[0]}"

layout="${next%%:*}"
variant=""
[[ "$next" == *:* ]] && variant="${next#*:}"

setxkbmap -layout "$layout" ${variant:+-variant "$variant"} -option "" -option "$XKB_OPTIONS"

notify-send -t 1200 -h string:x-canonical-private-synchronous:lang-switch \
    "Keyboard layout" "<b>${next^^}</b>"
