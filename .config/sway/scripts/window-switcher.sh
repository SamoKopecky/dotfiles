#!/bin/bash
# Fuzzel window switcher via sway IPC, with icons

chosen=$(swaymsg -t get_tree |
	jq -r '
		.. | objects
		| select(.type=="con" and .name)
		| [.id, (.app_id // .window_properties.class // "?"), .name]
		| @tsv
	' |
	awk -F'\t' '{ printf "%s\t[%s] %s\0icon\x1f%s\n", $1, $2, $3, tolower($2) }' |
	fuzzel --dmenu --prompt "Window " --width 80)

[ -z "$chosen" ] && exit 0

id=$(echo "$chosen" | cut -f1)
swaymsg "[con_id=$id] focus"
