#!/bin/bash
OUTPUT=$(swaync-client -swb)
COUNT=$(echo "$OUTPUT" | jq -r '.text')

if [ "$COUNT" = "0" ]; then
    echo ""
else
    echo "$OUTPUT"
fi
