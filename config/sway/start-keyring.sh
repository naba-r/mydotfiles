#!/usr/bin/env bash
set -euo pipefail

# Start (or replace) gnome-keyring and import the env vars it prints
eval "$(/usr/bin/gnome-keyring-daemon --replace --start --components=pkcs11,secrets,ssh)"

# Export for child processes + push into systemd/dbus activation env
export SSH_AUTH_SOCK
export GNOME_KEYRING_CONTROL

dbus-update-activation-environment --systemd \
  DISPLAY \
  WAYLAND_DISPLAY \
  XDG_CURRENT_DESKTOP=sway \
  SSH_AUTH_SOCK \
  GNOME_KEYRING_CONTROL
