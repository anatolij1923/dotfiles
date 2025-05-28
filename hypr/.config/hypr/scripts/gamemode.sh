#!/usr/bin/env sh

FLAG_FILE="$HOME/.config/1923/cache/gamemode_enabled"

# Создание директории, если её нет
mkdir -p "$HOME/.config/1923/cache"

if [ -f "$FLAG_FILE" ]; then
    # Gamemode выключается
    rm "$FLAG_FILE"
    hyprctl --batch "\
        keyword animations:enabled 1;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 1;\
        keyword general:gaps_in 10;\
        keyword general:gaps_out 20;\
        keyword general:border_size 3;\
        keyword decoration:rounding 20; \
        keyword input:touchpad:disable_while_typing 1 "
    notify-send "Gamemode" "Gamemode is turned off"
else
    # Gamemode включается
    touch "$FLAG_FILE"
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0;\
        keyword input:touchpad:disable_while_typing 0"

    notify-send "Gamemode" "Gamemode is turned on"
fi

