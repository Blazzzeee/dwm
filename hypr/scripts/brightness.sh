#!/usr/bin/env bash

ICON_DIR="$HOME/.config/hypr/scripts/brightness"  

# Send a notification with an appropriate PNG icon
notify_brightness() {
    local max cur pct icon

    max=$(brightnessctl max)           # Maximum brightness value :contentReference[oaicite:7]{index=7}
    cur=$(brightnessctl get)           # Current brightness value :contentReference[oaicite:8]{index=8}
    pct=$(( cur * 100 / max ))         # Integer percentage :contentReference[oaicite:9]{index=9}

    if   (( pct == 100 )); then icon="full.png"
    elif (( pct >  66  )); then icon="full-1.png"
    elif (( pct >  33  )); then icon="full-2.png"
    else                       icon="empty.png"
    fi

notify-send \
  "${pct}%" \
  "" \
  --hint string:image-path:"$ICON_DIR/$icon" \
  -t 1000
}

if [[ $# -lt 1 ]] || [[ ! $1 =~ ^(inc|dec)$ ]]; then
    echo "Usage: $0 [inc|dec] [step]" >&2
    exit 1
fi

ACTION=$1
STEP=${2:-10%}

if ! command -v brightnessctl &>/dev/null; then
    echo "Error: brightnessctl not found." >&2
    exit 1
fi

if [[ $ACTION == inc ]]; then
    brightnessctl set +$STEP &>/dev/null
else
    brightnessctl set $STEP- &>/dev/null
fi

notify_brightness
