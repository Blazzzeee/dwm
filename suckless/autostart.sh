#!/bin/sh
# ~/.dwm/autostart.sh

# Start dunst
if ! pgrep -x dunst >/dev/null; then
    dunst &
fi

# Start dwmblocks
dwmblocks &

# Set background
nitrogen --restore &

dwm
