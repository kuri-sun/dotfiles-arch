#!/bin/bash

# Toggle Eww dashboard visibility
if eww active-windows | grep -q "dashboard_window"; then
    # Dashboard is open, close it
    eww close dashboard_window
else
    # Dashboard is closed, open it
    eww open dashboard_window
fi
