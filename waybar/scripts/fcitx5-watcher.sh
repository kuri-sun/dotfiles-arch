#!/bin/bash

# Monitor fcitx5 input method changes and signal waybar
# This uses dbus-monitor to listen for fcitx5 input method changes

dbus-monitor --session "type='signal',interface='org.fcitx.Fcitx.InputMethod1'" 2>/dev/null | \
while read -r line; do
    if [[ "$line" == *"CurrentInputMethod"* ]]; then
        # Send signal 9 to waybar to update the language indicator
        pkill -RTMIN+9 waybar
    fi
done
