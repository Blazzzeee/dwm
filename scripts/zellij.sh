#!/usr/bin/env bash

# Strip ANSI colors
sessions=$(zellij list-sessions | awk '{print $1}' | sed 's/\x1B\[[0-9;]*[JKmsu]//g')

[[ -z "$sessions" ]] && { echo "No Zellij sessions found."; exit 1; }

# Use tofi instead of dmenu
selected=$(echo "$sessions" | dmenu -p "rescurrect: ")

[[ -z "$selected" ]] && exit 0

kitty -e zellij attach "$selected"
