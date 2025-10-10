#!/bin/bash

# Music player script using playerctl
# Supports any MPRIS-compatible media player (Spotify, VLC, etc.)

if ! command -v playerctl &> /dev/null; then
    case $1 in
        status) echo "stopped" ;;
        title) echo "N/A" ;;
        artist) echo "N/A" ;;
        cover) echo "" ;;
    esac
    exit 0
fi

case $1 in
    status)
        status=$(playerctl status 2>/dev/null)
        if [ -z "$status" ]; then
            echo "stopped"
        else
            echo "$status" | tr '[:upper:]' '[:lower:]'
        fi
        ;;
    title)
        title=$(playerctl metadata title 2>/dev/null)
        if [ -z "$title" ]; then
            echo "No Title"
        else
            echo "$title"
        fi
        ;;
    artist)
        artist=$(playerctl metadata artist 2>/dev/null)
        if [ -z "$artist" ]; then
            echo "Unknown Artist"
        else
            echo "$artist"
        fi
        ;;
    cover)
        cover=$(playerctl metadata mpris:artUrl 2>/dev/null)
        if [ -z "$cover" ]; then
            # Default cover image
            echo "/tmp/default_cover.png"
        else
            # Convert file:// URLs to local paths
            cover_path=$(echo "$cover" | sed 's|file://||')
            if [ -f "$cover_path" ]; then
                echo "$cover_path"
            else
                echo "/tmp/default_cover.png"
            fi
        fi
        ;;
    *)
        echo "Usage: $0 {status|title|artist|cover}"
        ;;
esac
