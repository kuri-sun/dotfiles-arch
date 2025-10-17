#!/bin/bash

# Audio monitoring script using wpctl (pipewire/wireplumber)
# Provides volume and mute status for EWW bar

case $1 in
    volume)
        # Get volume percentage for default sink
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
        ;;
    muted)
        # Check if muted (returns "true" or "false")
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "true" || echo "false"
        ;;
    icon)
        volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
        muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "true" || echo "false")

        if [ "$muted" = "true" ]; then
            echo "󰝟"
        elif [ $volume -ge 70 ]; then
            echo "󰕾"
        elif [ $volume -ge 30 ]; then
            echo "󰖀"
        else
            echo "󰕿"
        fi
        ;;
    *)
        echo "Usage: $0 {icon|volume|muted}"
        ;;
esac
