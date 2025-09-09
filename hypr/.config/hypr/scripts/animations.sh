#!/usr/bin/env sh

FLAG_FILE="$HOME/.cache/animations"

if [ -f "$FLAG_FILE" ]; then
    rm "$FLAG_FILE"
    hyprctl keyword animations:enabled 0
    notify-send -t 3000 -a "Animations" "Animations are turned off" 
else
    touch "$FLAG_FILE"
    hyprctl keyword animations:enabled 1
    notify-send -t 3000 -a "Animations" "Animations are turned on"
fi

