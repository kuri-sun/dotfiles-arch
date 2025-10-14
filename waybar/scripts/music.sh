#!/bin/bash

# Get current playing music info using playerctl

status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)

    # Limit length to avoid bar overflow
    if [ ${#title} -gt 25 ]; then
        title="${title:0:22}..."
    fi

    if [ ${#artist} -gt 20 ]; then
        artist="${artist:0:17}..."
    fi

    if [ "$status" = "Playing" ]; then
        icon="󰐊"
    else
        icon="󰏤"
    fi

    if [ -n "$artist" ] && [ -n "$title" ]; then
        echo "$icon $artist - $title"
    elif [ -n "$title" ]; then
        echo "$icon $title"
    else
        echo ""
    fi
else
    echo ""
fi
