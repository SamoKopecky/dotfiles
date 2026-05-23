#!/bin/bash
# Power menu via fuzzel

chosen=$(printf "󰌾  Lock\n󰗽  Logout\n󰒲  Suspend\n󰜉  Reboot\n󰐥  Shutdown" |
	fuzzel --dmenu --prompt "󰐥  " --lines 5)

case "$chosen" in
*Lock) hyprlock ;;
*Logout) swaymsg exit ;;
*Suspend) systemctl suspend ;;
*Reboot) systemctl reboot ;;
*Shutdown) systemctl poweroff ;;
esac
