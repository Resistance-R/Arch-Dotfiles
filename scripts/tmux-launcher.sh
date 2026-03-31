#!/bin/sh
set -eu

TMUX_BIN="$(command -v tmux || { echo 'tmux not found'; exit 1; })"
WOFI_BIN="$(command -v wofi || { echo 'wofi not found'; exit 1; })"

# 세션 목록
sessions="$("$TMUX_BIN" list-sessions -F '#{session_name}' 2>/dev/null || true)"

menu="Create new session…\n$sessions"

choice="$(printf '%b' "$menu" | "$WOFI_BIN" --dmenu -p "tmux sessions")"
[ -n "$choice" ] || exit 0

if [ "$choice" = "Create new session…" ]; then
    new_name="$(printf '' | "$WOFI_BIN" --dmenu -p "New session name:")"
    [ -n "$new_name" ] || exit 0
    session="$new_name"
    create=1
else
    session="$choice"
    create=0
fi

# tmux 내부
if [ -n "${TMUX-}" ]; then
    if [ "$create" -eq 1 ] && ! "$TMUX_BIN" has-session -t "$session" 2>/dev/null; then
        "$TMUX_BIN" new-session -ds "$session"
    fi
    exec "$TMUX_BIN" switch-client -t "$session"
fi

# tmux 외부 → kitty 실행
if [ "$create" -eq 1 ]; then
    exec kitty sh -lc "$TMUX_BIN new-session -s '$session'"
else
    exec kitty sh -lc "$TMUX_BIN attach -t '$session'"
fi
