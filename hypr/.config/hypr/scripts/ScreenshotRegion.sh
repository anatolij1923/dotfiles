#!/bin/bash

# Папка для скринов
SCREENSHOT_DIR="$(xdg-user-dir PICTURES)/Снимки экрана"
mkdir -p "$SCREENSHOT_DIR"

# Имя файла
FILENAME="$(date +'%s_grim.png')"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

# Захват области
grim -g "$(slurp -d)" "$FILEPATH"

# Копирование в буфер обмена (если установлен wl-copy)
if command -v wl-copy &>/dev/null; then
    wl-copy < "$FILEPATH"
fi

# Уведомление
notify-send "Сделан снимок экрана" "Снимок сохранен в $FILEPATH"
