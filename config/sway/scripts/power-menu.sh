#!/usr/bin/env bash

choice=$(printf "Power Off\nReboot\nLogout\nLock" | \
  fuzzel --dmenu --config ~/.config/sway/scripts/fuzzel-power.ini)

case "$choice" in
  "Power Off") systemctl poweroff ;;
  "Reboot")   systemctl reboot ;;
  "Logout")   swaymsg exit ;;
  "Lock")     ~/.config/sway/scripts/lock-with-sleep.sh ;;
esac
