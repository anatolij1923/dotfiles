#!/usr/bin/env bash

VIDEO_DIR="$(xdg-user-dir VIDEOS)/Запись экрана"
mkdir -p "$VIDEO_DIR"

FILENAME="$(date +'%s_record.mp4')"
FILEPATH="$VIDEO_DIR/$FILENAME"

# Если запись уже идёт — остановить
if pgrep -x wf-recorder > /dev/null; then
    pkill wf-recorder
    notify-send "Запись экрана" "Запись остановлена"
    exit 0
fi

# Старт записи
if [[ "$1" == "area" ]]; then
    GEOM="$(slurp -d)"
    [[ -z "$GEOM" ]] && exit 1
    wf-recorder -g "$GEOM" -f "$FILEPATH" & disown
else
    wf-recorder -f "$FILEPATH" & disown
fi

notify-send "Запись экрана" "Начата запись: $FILEPATH"
