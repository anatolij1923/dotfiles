#!/bin/bash

# Путь к папке с снимками экрана
SCREENSHOT_DIR="$(xdg-user-dir PICTURES)/Снимки экрана"

# Создание папки, если её нет
mkdir -p "$SCREENSHOT_DIR"

# Имя файла
FILENAME="$(date +'%s_grim.png')"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

# Снимок экрана
if [[ "$1" == "area" ]]; then
    GEOM="$(slurp -d)" 
    [[ -z "GEOM" ]] && exit 1
    grim -g "$GEOM" "$FILEPATH"
else
    grim "$FILEPATH"    
fi

# Копирование в буфер обмена (если установлен wl-copy)
if command -v wl-copy &> /dev/null; then
    wl-copy < "$FILEPATH"
fi

# Уведомление
notify-send "Сделан снимок экрана" "Снимок сохранен в $FILEPATH"
