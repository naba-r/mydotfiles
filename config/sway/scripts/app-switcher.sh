#!/usr/bin/env bash

choice=$(
  ~/.config/sway/scripts/list-windows.sh |
  fuzzel --dmenu --no-sort
)

[ -n "$choice" ] || exit

ws=$(echo "$choice" | grep -o '\[[0-9]*\]' | tr -d '[]')
swaymsg workspace "$ws"
