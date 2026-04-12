#!/bin/sh

FIREFOX_BIN="$(command -v firefox || { echo 'firefox not found'; exit 1; })"
WOFI_BIN="$(command -v wofi || { echo 'wofi not found'; exit 1; })"

# site list
default_menu=$(cat <<EOF
Open New Tab
youtube.com
flathub.org/ko
namu.wiki
github.com
EOF
)

choice="$(printf '%b' "$default_menu" | "$WOFI_BIN" --dmenu -p "search in firefox")"
[ -n "$choice" ] || exit 0

if [ "$choice" = "Open New Tab" ]; then # open new tab
    $FIREFOX_BIN &
elif printf '%s' "$choice" | grep -qE '^[^ ]+\.[^ ]+$'; then # open site url
  "$FIREFOX_BIN" --new-window "$choice" &
else # search keyword
  "$FIREFOX_BIN" --search "$choice" &
fi
