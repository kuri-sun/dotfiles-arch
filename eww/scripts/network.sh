#!/bin/bash

# Network monitoring script
# Gets network statistics for the primary interface

# Find the primary network interface (exclude lo, docker, veth, etc.)
get_interface() {
    ip route | grep '^default' | awk '{print $5}' | head -n1
}

INTERFACE=$(get_interface)
CACHE_DIR="/tmp/eww_net"
mkdir -p "$CACHE_DIR"

case $1 in
    upload)
        # Get current upload bytes
        current=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes 2>/dev/null || echo 0)
        prev=$(cat "$CACHE_DIR/upload_prev" 2>/dev/null || echo $current)
        echo $current > "$CACHE_DIR/upload_prev"

        # Calculate MB uploaded
        upload_mb=$(awk "BEGIN {printf \"%.2f\", ($current - $prev) / 1024 / 1024}")
        echo "$upload_mb"
        ;;
    download)
        # Get current download bytes
        current=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes 2>/dev/null || echo 0)
        prev=$(cat "$CACHE_DIR/download_prev" 2>/dev/null || echo $current)
        echo $current > "$CACHE_DIR/download_prev"

        # Calculate MB downloaded
        download_mb=$(awk "BEGIN {printf \"%.2f\", ($current - $prev) / 1024 / 1024}")
        echo "$download_mb"
        ;;
    upload_speed)
        # Get upload speed in KB/s
        current=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes 2>/dev/null || echo 0)
        prev=$(cat "$CACHE_DIR/upload_speed_prev" 2>/dev/null || echo $current)
        prev_time=$(cat "$CACHE_DIR/upload_time_prev" 2>/dev/null || echo $(date +%s))
        curr_time=$(date +%s)

        echo $current > "$CACHE_DIR/upload_speed_prev"
        echo $curr_time > "$CACHE_DIR/upload_time_prev"

        time_diff=$((curr_time - prev_time))
        if [ $time_diff -gt 0 ]; then
            speed=$(awk "BEGIN {printf \"%.2f\", ($current - $prev) / $time_diff / 1024}")
            echo "${speed}K"
        else
            echo "0K"
        fi
        ;;
    download_speed)
        # Get download speed in KB/s
        current=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes 2>/dev/null || echo 0)
        prev=$(cat "$CACHE_DIR/download_speed_prev" 2>/dev/null || echo $current)
        prev_time=$(cat "$CACHE_DIR/download_time_prev" 2>/dev/null || echo $(date +%s))
        curr_time=$(date +%s)

        echo $current > "$CACHE_DIR/download_speed_prev"
        echo $curr_time > "$CACHE_DIR/download_time_prev"

        time_diff=$((curr_time - prev_time))
        if [ $time_diff -gt 0 ]; then
            speed=$(awk "BEGIN {printf \"%.2f\", ($current - $prev) / $time_diff / 1024}")
            echo "${speed}K"
        else
            echo "0K"
        fi
        ;;
    *)
        echo "Usage: $0 {upload|download|upload_speed|download_speed}"
        ;;
esac
