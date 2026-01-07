#!/usr/bin/env bash

swaymsg -t get_tree | jq -r '
  .. | objects |
  select(.type == "workspace" and (.num or .name)) |
  . as $ws |
  ([$ws | .num // .name | tostring] | .[0]) as $ws_name |
  (
    ($ws | .nodes // []) + ($ws | .floating_nodes // [])
  ) |
  .. | objects |
  select(.type == "con" and (.app_id or (.window_properties | .class))) |
  (.app_id // .window_properties.class | tostring) as $app |
  select($app and ($app | length > 0) and $ws_name and ($ws_name | length > 0)) |
  "\($app) [\($ws_name)]"
' | sort -u
