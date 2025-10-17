#!/bin/bash

# Toggle calendar visibility
if eww active-windows | grep -q "calendar_window"; then
    # Calendar is open, close it
    eww close calendar_window
else
    # Calendar is closed, open it
    eww open calendar_window
fi
