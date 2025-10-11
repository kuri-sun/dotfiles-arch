#!/bin/bash
# ~/.config/hypr/scripts/startup.sh

echo "⏳ Waiting for PipeWire audio..."

# Wait for Pulse audio socket
while [ ! -S "$XDG_RUNTIME_DIR/pulse/native" ]; do
  sleep 0.3
done

echo "🚀 Launching Waybar..."
waybar &
