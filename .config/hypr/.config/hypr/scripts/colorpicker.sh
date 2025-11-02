#!/bin/bash

color=$(hyprpicker)

if [[ color == "" ]]; then
    echo Selection canceled
    pkill hyprpicker
    exit 0
fi

if [[ -n "$color"]]; then
    notify-send -i color-select-symbolic -a Color\ Picker $color
    wl-copy $color
fi
