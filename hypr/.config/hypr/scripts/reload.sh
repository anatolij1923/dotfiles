SCRIPTSDIR=$HOME/.config/hypr/scripts
UserScripts=$HOME/.config/hypr/UserScripts

# Define file_exists function
file_exists() {
    if [ -e "$1" ]; then
        return 0  # File exists
    else
        return 1  # File does not exist
    fi
}

# Kill already running processes
_ps=(waybar rofi swaync ags gjs)
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill "${_prs}"
    fi
done

# Quit ags
ags quit

# Launch ags
ags run ~/auralis/app.ts &

sleep 1
#Restart waybar
# waybar &

# relaunch swaync
sleep 0.5
# swaync > /dev/null 2>&1 &jsx@../../../home/anatolij1923/auralis-gtk4/widget/osd/OSD.tsx:75:13


exit 0
