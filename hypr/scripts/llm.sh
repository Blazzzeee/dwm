#!/bin/bash

VENV_PATH="$HOME/.config/hypr/.venv"
GEMINI_SCRIPT="$HOME/.config/hypr/scripts/gemini.py"

run_gemini() {
  query=$(rofi -dmenu -p "Ask Gemini:")

  if [[ -n "$query" ]]; then
alacritty --class "AI" -e bash -c "source \"$VENV_PATH/bin/activate\" && python \"$GEMINI_SCRIPT\" \"$query\" | bat --style=numbers --paging=always ; read -p 'Press enter to exit...'"
    fi
}

run_gemini
