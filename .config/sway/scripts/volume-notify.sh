#!/bin/sh
# Show volume OSD via dunst.
# Usage:
#   volume-notify.sh up     # raise +5%
#   volume-notify.sh down   # lower -5%
#   volume-notify.sh mute   # toggle mute
#   volume-notify.sh show   # just show current

case "$1" in
up) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
down) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
show) ;;
*)
	echo "usage: $0 up|down|mute|show" >&2
	exit 1
	;;
esac

vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1)
mute=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -oP '(?<=Mute: )\w+')

if [ "$mute" = "yes" ]; then
	dunstify -a "volume" -r 1000 -t 1500 -u normal \
		"Volume" "Muted" -h int:value:0
else
	dunstify -a "volume" -r 1000 -t 1500 -u normal \
		"Volume" "${vol}%" -h "int:value:${vol}"
fi
