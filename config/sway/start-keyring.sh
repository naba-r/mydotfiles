#!/bin/bash

# Initialize the keyring daemon (connect to the one PAM started or start a new one)
# We eval the output to set the environment variables in this script's scope
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)

# Export these variables to the DBus user session and Systemd
# This is the "Bridge" that lets Brave find the Keyring
export SSH_AUTH_SOCK
export GNOME_KEYRING_CONTROL

dbus-update-activation-environment --systemd \
    WAYLAND_DISPLAY \
    XDG_CURRENT_DESKTOP=sway \
    SSH_AUTH_SOCK \
    GNOME_KEYRING_CONTROL \
    DISPLAY
