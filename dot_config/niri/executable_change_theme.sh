#!/bin/bash
WALL_DIR="$HOME/Pictures/Wallpapa"
WALLPAPER=$(find "$WALL_DIR" -type f | shuf -n 1)
awww img "$WALLPAPER" --transition-type wipe --transition-duration 1.5 --transition-fps 60
wallust run -p saliencedark "$WALLPAPER"
pkill -USR2 waybar
pkill -USR1 micro
