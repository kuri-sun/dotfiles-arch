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
            cat "$CACHE_FILE"
            return
        fi
    fi

    # Fetch weather data and cache it
    curl -s "wttr.in/${LOCATION}?format=j1" > "$CACHE_FILE" 2>/dev/null
    cat "$CACHE_FILE"
}

case $1 in
    temp)
        weather_data=$(get_weather_data)
        echo "$weather_data" | jq -r '.current_condition[0].temp_C // "21"'
        ;;
    location)
        echo "$LOCATION"
        ;;
    condition)
        weather_data=$(get_weather_data)
        echo "$weather_data" | jq -r '.current_condition[0].weatherDesc[0].value // "Clear Sky"'
        ;;
    wind)
        weather_data=$(get_weather_data)
        speed=$(echo "$weather_data" | jq -r '.current_condition[0].windspeedKmph // "0"')
        echo "${speed} km/h"
        ;;
    humidity)
        weather_data=$(get_weather_data)
        humidity=$(echo "$weather_data" | jq -r '.current_condition[0].humidity // "62"')
        echo "${humidity}%"
        ;;
    icon)
        weather_data=$(get_weather_data)
        code=$(echo "$weather_data" | jq -r '.current_condition[0].weatherCode // "113"')
        # Map weather codes to nerd font icons
        case $code in
            113) echo "" ;;  # Clear/Sunny
            116) echo "" ;;  # Partly cloudy
            119|122) echo "" ;;  # Cloudy
            143|248|260) echo "" ;;  # Fog
            176|263|266|281|284|293|296|299|302|305|308|311|314|317|320|323|326|329|332|335|338|350|353|356|359|362|365|374|377) echo "" ;;  # Rain
            179|182|185|227|230|317|320|323|326|329|332|335|338|350|368|371|374|377) echo "" ;;  # Snow
            200|386|389|392|395) echo "" ;;  # Thunder
            *) echo "" ;;  # Default
        esac
        ;;
    *)
        echo "Usage: $0 {temp|location|condition|wind|humidity|icon}"
        ;;
esac
