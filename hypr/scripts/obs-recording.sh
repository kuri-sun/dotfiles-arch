#!/bin/bash

# OBS Recording Control Script
# This script starts/stops OBS screen recording

RECORDING_FILE="$HOME/Videos/recording_$(date +%Y%m%d_%H%M%S).mkv"

# Clean up old OBS logs and profiler data (keep only 3 most recent)
find ~/.config/obs-studio/logs/ -type f -name "*.txt" | sort -r | tail -n +4 | xargs -r rm -f
find ~/.config/obs-studio/profiler_data/ -type f -name "*.csv.gz" | sort -r | tail -n +4 | xargs -r rm -f

# Check if OBS is running
if ! pgrep -x "obs" > /dev/null; then
    # Start OBS in background (minimized)
    notify-send "OBS Recording" "Starting OBS Studio..."
    obs --minimize-to-tray --startvirtualcam &
    sleep 2
fi

# Check if currently recording
if obs-cli recording status 2>/dev/null | grep -q "Recording: true"; then
    # Stop recording
    obs-cli recording stop
    notify-send "OBS Recording" "Recording stopped and saved to Videos/"
else
    # Start recording
    obs-cli recording start
    notify-send "OBS Recording" "Recording started"
fi
