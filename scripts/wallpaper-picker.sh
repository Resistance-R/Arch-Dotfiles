#!/bin/sh

set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpaper"

# Extansions to support
mapfile -t files < <(
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
        | sort
)

# Exit if file does NOT exist
[ ${#files[@]} -eq 0 ] && {
    notify-send "Wallpaper" "Wallpaper File is NOT Exist: $WALLPAPER_DIR"
    exit 1
}

# Create the list of filenames to display in wofi
menu_entries=()
for file in "${files[@]}"; do
    menu_entries+=("$(basename "$file")")
done

# Select in wofi
selected=$(
    printf '%s\n' "${menu_entries[@]}" | \
    wofi --dmenu --prompt "wallpaper"
)

# Cancel when exit
[ -z "${selected:-}" ] && exit 0

# Find full path of selected wallpaper file
selected_path="$WALLPAPER_DIR/$selected"

[ ! -f "$selected_path" ] && {
    notify-send "Wallpaper" "The Selected File Cannot be Found."
    exit 1
}

# If the awww daemon is not running, run it.
if ! pgrep -x awww-daemon >/dev/null; then
    awww-daemon &
    sleep 0.5
fi

# Change wallpaper
awww img "$selected_path" \
    --transition-type grow \
    --transition-duration 1 \
    --transition-fps 60 \
    --transition-pos "$(shuf -n 1 -e center top-left top-right bottom-left bottom-right)"

notify-send "Wallpaper" "Applied: $selected"
