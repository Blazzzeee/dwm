#!/bin/bash
# dmenu Power Menu

# Options
options=" Suspend\n󰍃 Logout\n⏻ Shutdown\n Restart"

# Show dmenu
choice=$(echo -e "$options" | dmenu -i -l 4)

case "$choice" in
    " Suspend")
        systemctl suspend
        ;;
    "󰍃 Logout")
        pkill dwm
        ;;
    "⏻ Shutdown")
        systemctl poweroff
        ;;
    " Restart")
        systemctl reboot
        ;;
    *)
        exit 0
        ;;
esac
