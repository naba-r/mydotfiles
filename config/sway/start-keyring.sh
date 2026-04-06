#!/usr/bin/env bash
set -euo pipefail
eval "$(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
export SSH_AUTH_SOCK
export GNOME_KEYRING_CONTROL
dbus-update-activation-environment --systemd \
  DISPLAY \
  WAYLAND_DISPLAY \
  XDG_CURRENT_DESKTOP=sway \
  SSH_AUTH_SOCK \
  GNOME_KEYRING_CONTROL
