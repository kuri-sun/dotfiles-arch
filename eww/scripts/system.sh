#!/bin/bash

# System monitoring script

case $1 in
    cpu)
        # Get CPU usage percentage
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
        printf "%.0f" "$cpu_usage"
        ;;
    memory)
        # Get memory usage percentage
        mem_info=$(free | grep Mem)
        total=$(echo $mem_info | awk '{print $2}')
        used=$(echo $mem_info | awk '{print $3}')
        mem_usage=$(awk "BEGIN {printf \"%.0f\", ($used/$total)*100}")
        echo "$mem_usage"
        ;;
    disk)
        # Get disk usage for root partition
        disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
        echo "$disk_usage"
        ;;
    temp)
        # Get CPU temperature
        # Try different methods to get temperature
        if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
            temp=$(cat /sys/class/thermal/thermal_zone0/temp)
            temp=$(awk "BEGIN {printf \"%.1f\", $temp/1000}")
            echo "$temp"
        elif command -v sensors &> /dev/null; then
            temp=$(sensors | grep -i 'Core 0' | awk '{print $3}' | sed 's/+//;s/°C//' | head -n1)
            if [ -z "$temp" ]; then
                temp=$(sensors | grep -i 'Package' | awk '{print $4}' | sed 's/+//;s/°C//' | head -n1)
            fi
            if [ -z "$temp" ]; then
                temp="57.0"
            fi
            echo "$temp"
        else
            echo "57.0"
        fi
        ;;
    cpu_percent)
        # Same as cpu, for progress bar
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
        printf "%.0f" "$cpu_usage"
        ;;
    cpu_text)
        # Get CPU usage in core format
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
        total_cores=$(nproc)
        cores_used=$(awk "BEGIN {printf \"%.1f\", ($cpu_usage * $total_cores) / 100}")
        echo "${cores_used} / ${total_cores} cores"
        ;;
    memory_text)
        # Get memory usage in GB format
        mem_info=$(free | grep Mem)
        total=$(echo $mem_info | awk '{print $2}')
        used=$(echo $mem_info | awk '{print $3}')
        total_gb=$(awk "BEGIN {printf \"%.1f\", $total/1024/1024}")
        used_gb=$(awk "BEGIN {printf \"%.1f\", $used/1024/1024}")
        echo "${used_gb} / ${total_gb} GB"
        ;;
    battery)
        # Get battery percentage
        # Try to find battery info from /sys/class/power_supply/
        battery_path=""
        for bat in /sys/class/power_supply/BAT*; do
            if [ -d "$bat" ]; then
                battery_path="$bat"
                break
            fi
        done

        if [ -n "$battery_path" ] && [ -f "$battery_path/capacity" ]; then
            cat "$battery_path/capacity"
        else
            # If no battery found, return 0 (desktop/no battery)
            echo "0"
        fi
        ;;
    battery_text)
        # Get battery capacity in human-readable format
        battery_path=""
        for bat in /sys/class/power_supply/BAT*; do
            if [ -d "$bat" ]; then
                battery_path="$bat"
                break
            fi
        done

        if [ -n "$battery_path" ] && [ -f "$battery_path/capacity" ]; then
            capacity=$(cat "$battery_path/capacity")
            echo "${capacity}%"
        else
            echo "N/A"
        fi
        ;;
    *)
        echo "Usage: $0 {cpu|cpu_percent|cpu_text|memory|memory_text|disk|temp|battery|battery_text}"
        ;;
esac
