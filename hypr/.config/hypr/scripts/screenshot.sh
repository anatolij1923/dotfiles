#!/bin/bash

SCREENSHOT_DIR="$(xdg-user-dir PICTURES)/Screenshots"

mkdir -p "$SCREENSHOT_DIR"

FILENAME="$(date +'%s_grim.png')"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

if [[ "$1" == "area" ]]; then
    GEOM="$(slurp -d -b "#38383883" -c "#f3f3f3" )" 
    if  [ $? -ne 0 ]; then
        exit 1;
    fi
    [[ -z "GEOM" ]] && exit 1
    grim -g "$GEOM" "$FILEPATH"
else
    grim "$FILEPATH"    
fi

if command -v wl-copy &> /dev/null; then
    wl-copy < "$FILEPATH"
fi

notify-send  -a "Screenshot" "Screenshot saved in" "$FILEPATH"
