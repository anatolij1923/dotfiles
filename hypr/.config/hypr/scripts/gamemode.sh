#!/usr/bin/env sh

FLAG_FILE="$HOME/.cache/gamemode"

if [ -f "$FLAG_FILE" ]; then
    rm "$FLAG_FILE"
    hyprctl --batch "\
        keyword animations:enabled 1;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 1;\
        keyword general:gaps_in 10;\
        keyword general:gaps_out 20;\
        keyword general:border_size 0;\
        keyword decoration:rounding 20; \
        keyword input:touchpad:disable_while_typing 1 "
    notify-send -a "Gamemode" "Gamemode is turned off"
else
    touch "$FLAG_FILE"
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 0;\
        keyword decoration:rounding 0;\
        keyword input:touchpad:disable_while_typing 0"

    notify-send -a "Gamemode" "Gamemode is turned on"
fi

