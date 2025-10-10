#!/bin/bash

# Storage monitoring script for root partition

case $1 in
    total)
        # Get total storage
        df -h / | awk 'NR==2 {print $2}'
        ;;
    used)
        # Get used storage
        df -h / | awk 'NR==2 {print $3}'
        ;;
    free)
        # Get free storage
        df -h / | awk 'NR==2 {print $4}'
        ;;
    percent)
        # Get usage percentage
        df -h / | awk 'NR==2 {print $5}' | sed 's/%//'
        ;;
    *)
        echo "Usage: $0 {total|used|free|percent}"
        ;;
esac
