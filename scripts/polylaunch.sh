#!/bin/sh

# kill polybar and wait for it to shut down
pgrep -x polybar | xargs -r kill -9
while pgrep -x polybar >/dev/null; do sleep 1; done

for m in $(xrandr -q | rg " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload top &
done

