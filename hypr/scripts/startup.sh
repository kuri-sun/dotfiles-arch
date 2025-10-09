#!/bin/bash
# ~/.config/hypr/scripts/startup.sh

echo "⏳ Waiting for PipeWire audio..."

# Wait for Pulse audio socket
while [ ! -S "$XDG_RUNTIME_DIR/pulse/native" ]; do
    sleep 0.3
done

echo "🎧 Audio ready, launching Spotify..."
# Launch Spotify if not already running
pgrep spotify >/dev/null || spotify &

# Wait a few seconds for Spotify MPRIS to initialize
sleep 5

echo "🚀 Launching Waybar..."
waybar &
