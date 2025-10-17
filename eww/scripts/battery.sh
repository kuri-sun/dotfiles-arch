#!/bin/bash

# Battery monitoring script
# Provides battery status for EWW bar

BATTERY_PATH="/sys/class/power_supply/BAT0"

if [ ! -d "$BATTERY_PATH" ]; then
    # Try BAT1 if BAT0 doesn't exist
    BATTERY_PATH="/sys/class/power_supply/BAT1"
fi

if [ ! -d "$BATTERY_PATH" ]; then
    # No battery found
    case $1 in
        icon) echo "" ;;
        percent) echo "0" ;;
        status) echo "No Battery" ;;
    esac
    exit 0
fi

case $1 in
    percent)
        cat "$BATTERY_PATH/capacity" 2>/dev/null || echo "0"
        ;;
    status)
        status=$(cat "$BATTERY_PATH/status" 2>/dev/null)
        echo "$status"
        ;;
    icon)
        percent=$(cat "$BATTERY_PATH/capacity" 2>/dev/null || echo "0")
        status=$(cat "$BATTERY_PATH/status" 2>/dev/null)

        if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
            echo "󰂄"
        elif [ $percent -ge 90 ]; then
            echo "󰁹"
        elif [ $percent -ge 70 ]; then
            echo "󰂀"
        elif [ $percent -ge 50 ]; then
            echo "󰁾"
        elif [ $percent -ge 30 ]; then
            echo "󰁻"
        elif [ $percent -ge 15 ]; then
            echo "󰁺"
        else
            echo "󰂎"
        fi
        ;;
    *)
        echo "Usage: $0 {icon|percent|status}"
        ;;
esac
