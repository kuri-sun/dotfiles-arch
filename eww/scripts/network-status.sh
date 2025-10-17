#!/bin/bash

# Network status monitoring script
# Provides connection status for EWW bar

get_interface() {
    ip route | grep '^default' | awk '{print $5}' | head -n1
}

get_interface_type() {
    local interface=$1
    if [ -z "$interface" ]; then
        echo "disconnected"
        return
    fi

    # Check if wireless
    if [ -d "/sys/class/net/$interface/wireless" ]; then
        echo "wifi"
    else
        echo "ethernet"
    fi
}

get_wifi_ssid() {
    local interface=$1
    if command -v nmcli &> /dev/null; then
        nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2
    else
        iw dev "$interface" link | grep SSID | awk '{print $2}'
    fi
}

INTERFACE=$(get_interface)
TYPE=$(get_interface_type "$INTERFACE")

case $1 in
    icon)
        case $TYPE in
            wifi) echo "󰤨" ;;
            ethernet) echo "󰈁" ;;
            disconnected) echo "󰤭" ;;
        esac
        ;;
    type)
        echo "$TYPE"
        ;;
    ssid)
        if [ "$TYPE" = "wifi" ]; then
            get_wifi_ssid "$INTERFACE"
        else
            echo "$TYPE"
        fi
        ;;
    interface)
        echo "$INTERFACE"
        ;;
    *)
        echo "Usage: $0 {icon|type|ssid|interface}"
        ;;
esac
