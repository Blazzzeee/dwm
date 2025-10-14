#!/bin/bash

source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt='Screenshot'
mesg="DIR: /home/blazzee/Pictures/Screenshot"

if [[ "$theme" == *'type-1'* ]]; then
	list_col='1'
	list_row='5'
	win_width='400px'
elif [[ "$theme" == *'type-3'* ]]; then
	list_col='1'
	list_row='5'
	win_width='120px'
elif [[ "$theme" == *'type-5'* ]]; then
	list_col='1'
	list_row='5'
	win_width='520px'
elif [[ "$theme" == *'type-2'* || "$theme" == *'type-4'* ]]; then
	list_col='5'
	list_row='1'
	win_width='670px'
fi

layout=$(grep 'USE_ICON' "${theme}" | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
	option_1=" Capture Desktop"
	option_2=" Capture Area"
	option_3=" Capture Window"
	option_4=" Capture in 5s"
	option_5=" Capture in 10s"
else
	option_1=""
	option_2=""
	option_3=""
	option_4=""
	option_5=""
fi

rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme "${theme}"
}

run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

time=$(date +%Y-%m-%d-%H-%M-%S)
dir="$HOME/Pictures/Screenshot"
file="Screenshot_${time}.png"

mkdir -p "$dir"

notify_view() {
	notify-send "Screenshot" "Copied to clipboard."
	imv "$dir/$file" &
	if [[ -e "$dir/$file" ]]; then
		notify-send "Screenshot" "Screenshot Saved."
	else
		notify-send "Screenshot" "Screenshot Deleted."
	fi
}

copy_shot() {
	tee "$file" | wl-copy --type image/png
}

countdown() {
	for sec in $(seq "$1" -1 1); do
		notify-send -t 1000 "Screenshot" "Taking shot in: $sec"
		sleep 1
	done
}

shotnow() {
	cd "$dir" && grim "$file" && wl-copy < "$file"
	notify_view
}

shot5() {
	countdown 5
	shotnow
}

shot10() {
	countdown 10
	shotnow
}

shotwin() {
	# No window selection API in dwl, fallback to manual area
	cd "$dir" && slurp | grim -g - "$file" && wl-copy < "$file"
	notify_view
}

shotarea() {
	cd "$dir" && slurp | grim -g - "$file" && wl-copy < "$file"
	notify_view
}

run_cmd() {
	case "$1" in
		--opt1) shotnow ;;
		--opt2) shotarea ;;
		--opt3) shotwin ;;
		--opt4) shot5 ;;
		--opt5) shot10 ;;
	esac
}

chosen="$(run_rofi)"
case "${chosen}" in
	$option_1) run_cmd --opt1 ;;
	$option_2) run_cmd --opt2 ;;
	$option_3) run_cmd --opt3 ;;
	$option_4) run_cmd --opt4 ;;
	$option_5) run_cmd --opt5 ;;
esac
