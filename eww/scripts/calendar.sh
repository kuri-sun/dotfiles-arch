#!/bin/bash

# Calendar script for eww

case "$1" in
    "year")
        date '+%Y'
        ;;
    "month")
        date '+%B'
        ;;
    "month-short")
        date '+%b' | tr '[:lower:]' '[:upper:]'
        ;;
    "current-day")
        date '+%d' | sed 's/^0//'
        ;;
    "week"*)
        # Extract week number (week0, week1, etc.)
        week_num="${1#week}"

        # Get the current year and month
        current_year=$(date '+%Y')
        current_month=$(date '+%m')
        current_day=$(date '+%d' | sed 's/^0//')

        # Get the first day of the month (0=Sunday, 1=Monday, etc.)
        first_day=$(date -d "${current_year}-${current_month}-01" '+%u')
        # Convert to Sunday=0 format
        if [ "$first_day" -eq 7 ]; then
            first_day=0
        fi

        # Get number of days in current month
        days_in_month=$(date -d "${current_year}-${current_month}-01 +1 month -1 day" '+%d')

        # Generate one week (7 days)
        output="["
        day_counter=1

        start_pos=$((week_num * 7))
        end_pos=$((start_pos + 7))

        for ((i=start_pos; i<end_pos; i++)); do
            # Add leading spaces for first week
            if [ $i -lt $first_day ]; then
                output="${output}{\"day\":\"\",\"current\":\"false\"}"
            # Add days of the month
            elif [ $day_counter -le $days_in_month ]; then
                # Calculate which day this cell represents
                day_value=$((i - first_day + 1))
                if [ $day_value -le $days_in_month ] && [ $day_value -gt 0 ]; then
                    is_current="false"
                    if [ $day_value -eq $current_day ]; then
                        is_current="true"
                    fi
                    output="${output}{\"day\":\"$day_value\",\"current\":\"$is_current\"}"
                    day_counter=$((day_value + 1))
                else
                    output="${output}{\"day\":\"\",\"current\":\"false\"}"
                fi
            # Add trailing empty cells
            else
                output="${output}{\"day\":\"\",\"current\":\"false\"}"
            fi

            # Add comma between elements
            if [ $i -lt $((end_pos - 1)) ]; then
                output="${output},"
            fi
        done

        output="${output}]"
        echo "$output"
        ;;
    *)
        echo "Usage: $0 {year|month|month-short|current-day|week0-5}"
        exit 1
        ;;
esac
