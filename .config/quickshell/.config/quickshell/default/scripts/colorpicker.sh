#!/usr/bin/env bash

color="$(hyprpicker -a)"

if [[ -z "$color" ]]; then
    exit 0
fi

printf '%s' "$color" | wl-copy

notify-send \
    -a "Color Picker" \
    "Color copied" "$color"
