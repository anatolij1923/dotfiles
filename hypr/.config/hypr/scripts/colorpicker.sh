#!/bin/bash

color=$(hyprpicker)

if [[ color == "" ]]; then
    echo Selection canceled
    exit 0
fi

notify-send -i color-select-symbolic -a Color\ Picker $color
wl-copy $color
