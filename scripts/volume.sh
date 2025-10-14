#!/usr/bin/env bash

ICON_DIR="$HOME/.config/scripts/volume"
STEP="10%"

# Send a notification with an appropriate PNG icon
notify_volume() {
    local vol muted icon

    vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')
    vol=${vol%.*}  # Trim decimal part
    muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "yes" || echo "no")

    if [[ $muted == "yes" ]]; then
        icon="muted.png"
        vol="Muted"
    else
        if   (( vol > 66 )); then icon="full.png"
        elif (( vol > 33 )); then icon="full-1.png"
        else                     icon="full-2.png"
        fi
        vol="${vol}%"
    fi

    notify-send \
      --replace-id=778 \
      -a "Volume" \
      "$vol" \
      "" \
      --hint string:image-path:"$ICON_DIR/$icon" \
      --hint string:category:audio.volume \
      -t 1000
}

if [[ $# -lt 1 ]] || [[ ! $1 =~ ^(inc|dec|toggle)$ ]]; then
    echo "Usage: $0 [inc|dec|toggle]" >&2
    exit 1
fi

ACTION=$1

if ! command -v wpctl &>/dev/null; then
    echo "Error: wpctl not found." >&2
    exit 1
fi

case $ACTION in
    inc) wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ $STEP+ ;;
    dec) wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ $STEP- ;;
    toggle) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
esac

notify_volume
