#!/bin/bash

# Weather script using wttr.in
# Location can be passed as second argument
LOCATION="${2:-Tokyo}"  # Default to Tokyo

# Cache file to avoid too many API calls
CACHE_FILE="/tmp/eww_weather_cache_${LOCATION}"
CACHE_DURATION=1800  # 30 minutes in seconds

get_weather_data() {
    if [ -f "$CACHE_FILE" ]; then
        cache_age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)))
        if [ $cache_age -lt $CACHE_DURATION ]; then
            # Check if cache contains valid JSON
            if jq -e . "$CACHE_FILE" >/dev/null 2>&1; then
                cat "$CACHE_FILE"
                return
            fi
        fi
    fi

    # Fetch weather data and cache it
    weather_json=$(curl -s "wttr.in/${LOCATION}?format=j1" 2>/dev/null)

    # Only cache if we got valid JSON data
    if echo "$weather_json" | jq -e . >/dev/null 2>&1; then
        echo "$weather_json" > "$CACHE_FILE"
        echo "$weather_json"
    else
        # Return empty on failure - let jq defaults handle it
        echo ""
    fi
}

case $1 in
    temp)
        weather_data=$(get_weather_data)
        if [ -n "$weather_data" ]; then
            echo "$weather_data" | jq -r '.current_condition[0].temp_C // "21"'
        else
            echo "21"
        fi
        ;;
    location)
        echo "$LOCATION"
        ;;
    condition)
        weather_data=$(get_weather_data)
        if [ -n "$weather_data" ]; then
            echo "$weather_data" | jq -r '.current_condition[0].weatherDesc[0].value // "Clear Sky"'
        else
            echo "Clear Sky"
        fi
        ;;
    wind)
        weather_data=$(get_weather_data)
        if [ -n "$weather_data" ]; then
            speed=$(echo "$weather_data" | jq -r '.current_condition[0].windspeedKmph // "0"')
        else
            speed="0"
        fi
        echo "${speed} km/h"
        ;;
    humidity)
        weather_data=$(get_weather_data)
        if [ -n "$weather_data" ]; then
            humidity=$(echo "$weather_data" | jq -r '.current_condition[0].humidity // "62"')
        else
            humidity="62"
        fi
        echo "${humidity}%"
        ;;
    icon)
        weather_data=$(get_weather_data)
        if [ -n "$weather_data" ]; then
            code=$(echo "$weather_data" | jq -r '.current_condition[0].weatherCode // "113"')
        else
            code="113"
        fi
        # Map weather codes to nerd font icons
        case $code in
            113) echo "󰖙" ;;  # Clear/Sunny
            116) echo "󰖕" ;;  # Partly cloudy
            119|122) echo "󰖐" ;;  # Cloudy
            143|248|260) echo "󰖑" ;;  # Fog
            176|263|266|281|284|293|296|299|302|305|308|311|314|317|320|323|326|329|332|335|338|350|353|356|359|362|365|374|377) echo "󰖗" ;;  # Rain
            179|182|185|227|230|317|320|323|326|329|332|335|338|350|368|371|374|377) echo "󰖘" ;;  # Snow
            200|386|389|392|395) echo "󰖓" ;;  # Thunder
            *) echo "󰖐" ;;  # Default
        esac
        ;;
    *)
        echo "Usage: $0 {temp|location|condition|wind|humidity|icon}"
        ;;
esac
