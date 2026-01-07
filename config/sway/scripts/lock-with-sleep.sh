#!/bin/bash

# Kill any existing swayidle to avoid conflicts
pkill -x swayidle 2>/dev/null || true

# Start swayidle: after 20s idle → screen off, on activity → screen on
swayidle -w \
    timeout 20 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' &
IDLE_PID=$!

# Lock screen (stays in foreground)
gtklock

# When unlocked, cleanup
kill $IDLE_PID 2>/dev/null || true
swaymsg "output * dpms on"
