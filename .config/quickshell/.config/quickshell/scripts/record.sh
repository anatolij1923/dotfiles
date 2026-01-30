#!/usr/bin/bash

if command -v xdg-user-dir &>/dev/null; then
    RECORDING_DIR="$(xdg-user-dir VIDEOS)"

elif [[ -n "$XDG_VIDEOS_DIR" ]]; then
    RECORDING_DIR="$XDG_VIDEOS_DIR"

else
    RECORDING_DIR="$HOME/Videos"
fi

mkdir -p $RECORDING_DIR

getdate() {
    date '+%Y-%m-%d_%H-%M-%S'
}

getactivemonitor() {
    hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'
}

if pgrep -x "wf-recorder" >/dev/null; then
    notify-send "Screen recording" "Record saved at $FILENAME" -a 'Recorder'
    pkill -SIGINT wf-recorder
else
    FILENAME="$RECORDING_DIR/Recording_$(getdate).mp4"
    notify-send "Screen recording" "Started recording" -a 'Recorder'

    wf-recorder -o "$(getactivemonitor)" --pixel-format yuv420p -f "$FILENAME" -t &
    disown
fi
