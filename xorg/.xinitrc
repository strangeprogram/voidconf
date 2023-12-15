#!/bin/sh
xset +fp /usr/share/fonts/local
xset fp rehash

dunst &
slstatus &
unclutter &

# Example of dual monitor setup
#{ sleep 2; xrandr --output HDMI1 --mode 1920x1080 --output DP1 --mode 1920x1080 --above HDMI1; } &

exec dwm
