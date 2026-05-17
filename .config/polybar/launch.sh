#!/usr/bin/env bash
# Spawn polybar on every connected monitor.
# Monitor-agnostic: works on any PC, no hardcoded output names.

killall -q polybar
while pgrep -x polybar >/dev/null; do sleep 0.2; done

for m in $(polybar --list-monitors | cut -d: -f1); do
    MONITOR=$m polybar --reload main &
done
