#!/bin/bash
# Count notifications via makoctl (Lightweight)
# jq 'length' counts array entries. The previous `grep -c "id"` also counted any
# notification whose text merely contained "id" (e.g. summary "video id ready"),
# and broke when makoctl emits nothing at all.
COUNT=$(makoctl list 2>/dev/null | jq 'length' 2>/dev/null)
COUNT=${COUNT:-0}
if [ "$COUNT" -eq "0" ]; then
    echo "{\"text\": \"\", \"class\": \"none\"}"
else
    echo "{\"text\": \"󰂚 $COUNT\", \"class\": \"active\"}"
fi
