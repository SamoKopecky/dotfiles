#!/usr/bin/env bash
# Spawn polybar on every connected monitor.
# Tray pinned to primary monitor (deterministic — no random switching).

killall -q polybar
while pgrep -x polybar >/dev/null; do sleep 0.2; done

primary=$(xrandr --query | awk '/ connected primary/ {print $1}')

for m in $(polybar --list-monitors | cut -d: -f1); do
    if [ "$m" = "$primary" ]; then
        MONITOR=$m polybar --reload main &
    else
        MONITOR=$m polybar --reload secondary &
    fi
done
