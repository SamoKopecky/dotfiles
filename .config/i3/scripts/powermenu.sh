#!/bin/bash
# Power menu via rofi

chosen=$(printf "  Lock\n  Logout\n  Suspend\n  Reboot\n  Shutdown" \
         | rofi -dmenu -i -p "Power" -lines 5)

case "$chosen" in
    *Lock)     xsecurelock ;;
    *Logout)   i3-msg exit ;;
    *Suspend)  systemctl suspend ;;
    *Reboot)   systemctl reboot ;;
    *Shutdown) systemctl poweroff ;;
esac
