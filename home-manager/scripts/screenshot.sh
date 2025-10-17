#!/bin/bash

# Ensure screenshot folder exists
mkdir -p ~/Pictures/Screenshots

# Set filename with timestamp
FILE=~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png

# Take screenshot, save, and copy to clipboard
maim -g "$(slop)" | tee "$FILE" | xclip -selection clipboard -t image/png

# Show notification with the screenshot
notify-send "Screenshot saved" "$FILE" -i "$FILE"
