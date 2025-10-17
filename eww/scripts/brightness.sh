#!/bin/bash

# Brightness monitoring script
# Works with brightnessctl

case $1 in
    percent)
        # Get brightness percentage
        brightnessctl -m | awk -F, '{print $4}' | tr -d '%'
        ;;
    icon)
        brightness=$(brightnessctl -m | awk -F, '{print $4}' | tr -d '%')

        if [ $brightness -ge 75 ]; then
            echo "󰃠"
        elif [ $brightness -ge 50 ]; then
            echo "󰃟"
        elif [ $brightness -ge 25 ]; then
            echo "󰃞"
        else
            echo "󰃝"
        fi
        ;;
    *)
        echo "Usage: $0 {percent|icon}"
        ;;
esac
