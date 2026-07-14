#!/bin/bash

SAVE_DIR="/home/vlad/hdd/videoflud"
mkdir -p "$SAVE_DIR"

# Генерируем уникальное имя файла по дате и времени
FILE_PATH="$SAVE_DIR/rec_$(date +%Y-%m-%d_%H-%M-%S).mp4"

# Проверяем, установлена ли утилита записи
if ! command -v wl-screenrec &> /dev/null; then
    notify-send -a "Рекордер" "Ошибка: wl-screenrec не установлен"
    exit 1
fi

# Запускаем запись
notify-send -t 1500 -a "Рекордер" "Запись началась"
wl-screenrec -f "$FILE_PATH"
