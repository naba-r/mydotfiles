#!/bin/bash
# Count notifications via makoctl (Lightweight)
COUNT=$(makoctl list | grep -c "id")
if [ "$COUNT" -eq "0" ]; then
    echo "{\"text\": \"\", \"class\": \"none\"}"
else
    echo "{\"text\": \"󰂚 $COUNT\", \"class\": \"active\"}"
fi
