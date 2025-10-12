#!/bin/bash

# OBS Studio Control Script
# This script opens OBS Studio (minimized to tray)

# Clean up old OBS logs and profiler data (keep only 3 most recent)
find ~/.config/obs-studio/logs/ -type f -name "*.txt" | sort -r | tail -n +4 | xargs -r rm -f
find ~/.config/obs-studio/profiler_data/ -type f -name "*.csv.gz" | sort -r | tail -n +4 | xargs -r rm -f

# Check if OBS is running
if ! pgrep -x "obs" > /dev/null; then
    # Start OBS in background (minimized)
    notify-send "OBS Studio" "Starting OBS Studio..."
    obs --minimize-to-tray &
else
    notify-send "OBS Studio" "OBS is already running"
fi
