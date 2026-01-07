#!/bin/sh

# 1. Kill existing instances safely
pkill -f "wl-paste" 2>/dev/null

# 2. Wait a moment to ensure they are dead
sleep 0.5

# 3. Set Cache Directory (fallback to ~/.cache if variable is unset)
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/clipman"
mkdir -p "$CACHE_DIR"

# 4. Start the watcher
# Note: We do NOT use --no-primary. 
# wl-paste watches the standard clipboard by default and ignores mouse selections.
nohup wl-paste -t text --watch clipman store --max-items=50 \
    > "$CACHE_DIR/stdout.log" \
    2> "$CACHE_DIR/stderr.log" &
