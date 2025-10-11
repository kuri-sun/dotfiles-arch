#!/bin/bash

# Check if Eww dashboard is open and output JSON for waybar
if eww active-windows | grep -q "dashboard_window"; then
  # Dashboard is open - add active class
  echo '{"text":"󰣇","class":"active","tooltip":"Arch Linux 🖖 (Dashboard Open)"}'
else
  # Dashboard is closed
  echo '{"text":"󰣇","class":"","tooltip":"Arch Linux 🖖"}'
fi
