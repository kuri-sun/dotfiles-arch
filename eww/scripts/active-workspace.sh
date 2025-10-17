#!/bin/bash

# Output current workspace immediately
hyprctl activeworkspace -j | jq -r '.id'

# Listen for workspace changes with unbuffered output
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | \
    stdbuf -o0 grep --line-buffered "^workspace>>" | \
    while read -r line; do
        hyprctl activeworkspace -j | jq -r '.id'
    done
