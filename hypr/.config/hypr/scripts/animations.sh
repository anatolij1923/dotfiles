#!/usr/bin/env sh

FLAG_FILE="$HOME/.config/1923/cache/animations_enabled"

# Убедиться, что директория существует
mkdir -p "$HOME/.config/1923/cache"

if [ -f "$FLAG_FILE" ]; then
    # Анимации выключаются
    rm "$FLAG_FILE"
    hyprctl keyword animations:enabled 0
    notify-send -a "Animations" "Animations are turned off" 
else
    # Анимации включаются
    touch "$FLAG_FILE"
    hyprctl keyword animations:enabled 1
    notify-send -a "Animations" "Animations are turned on"
fi

