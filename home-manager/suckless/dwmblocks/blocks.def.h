// Modify this file to change what commands output to your statusbar, and
// recompile using the make command.
/*Icon*/ /*Command*/ /*Update Interval*/ /*Update Signal*/
static const Block blocks[] = {
    // {" ", "playerctl metadata --format '{{ artist }} - {{ title }}' 2>/dev/null || echo", 5, 0},
    //
    // { "proj: ", "cat ~/.current_project || echo 'none'", 2*60, 0 },
    {"󰤢 ", "iw dev wlan0 link | awk '/SSID/ {print $2}' || echo n/a", 10, 0 },
    {"󰂱 ",
     "bluetoothctl info | grep 'Connected: yes' > /dev/null && bluetoothctl "
     "info | grep 'Name' | awk '{print $2}' || echo n/a",
     5, 0},
    { " ", "powerprofilesctl get", 1, 0 },
    {"󰕾 ", "pamixer --get-volume | awk '{print $1}'", 5, 0},
    {" ", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g", 30, 0},
    {"  ", "acpi -b | awk -F', ' '{gsub(\"%\", \"\", $2); if ($1 ~ /Charging/) print $2 \" ch\"; else print $2 \" dis\"}'", 60, 0},
    {"", "date '+%b %d %I:%M %p'", 60 , 0},
};

// sets delimiter between status commands. NULL character ('\0') means no
// delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 3;
