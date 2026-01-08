#!/usr/bin/env bash

outputs=$(swaymsg -t get_outputs -r | jq -r '.[] | select(.active) | .name')

for out in $outputs; do
    if [[ "$out" == Virtual-* ]]; then
        # VM: pick sane resolution only
        preferred=$(swaymsg -t get_outputs -r | jq -r \
            --arg o "$out" '
            .[] | select(.name==$o) |
            .modes[] |
            select(
                (.width==1920 and .height==1080) or
                (.width==2560 and .height==1440)
            ) |
            "\(.width)x\(.height)"
            ' | head -n1)

        # Fallback if none matched
        mode="${preferred:-1920x1080}"
        scale=1

    else
        # Real hardware: highest native mode
        mode=$(swaymsg -t get_outputs -r | jq -r \
            --arg o "$out" '
            .[] | select(.name==$o) |
            .modes |
            sort_by(.width * .height) |
            last |
            "\(.width)x\(.height)"
            ')
        scale=1
    fi

    swaymsg output "$out" mode "$mode" scale "$scale"
done
