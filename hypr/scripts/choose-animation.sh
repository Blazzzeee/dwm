#!/usr/bin/env bash

# Path to animation configs
ANIM_DIR="/home/blazzee/.config/hypr/animations"
TARGET="/home/blazzee/.config/hypr/animation.conf"

# Get a list of animation config filenames
choices=$(ls "$ANIM_DIR"/*.conf | xargs -n 1 basename)

# Use rofi to let user select one
selected=$(echo "$choices" | tofi --config ~/.config/tofi/dmenu --prompt-text "Anim: ")

# Exit if nothing selected
[ -z "$selected" ] && exit

# Apply selection by sourcing (copying) into animations.conf
echo "# Sourced from $selected" > "$TARGET"
cat "$ANIM_DIR/$selected" >> "$TARGET"

notify-send "Hyprland" "Animation set to: $selected"
