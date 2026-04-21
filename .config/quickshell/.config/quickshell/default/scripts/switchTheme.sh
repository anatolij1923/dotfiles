#!/usr/bin/bash

get_current_mode() {
    gsettings get org.gnome.desktop.interface color-scheme | tr -d "'"
}

switch_theme() {
    current=$(get_current_mode)

    if [[ "$current" == "prefer-dark" ]]; then
        next="prefer-light"
    else
        next="prefer-dark"
    fi

    gsettings set org.gnome.desktop.interface color-scheme "$next"
    # notify-send "Theme switched" "$current → $next"
}

switch_theme
