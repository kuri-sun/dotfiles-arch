#!/usr/bin/env bash

# Check if Wofi is already running
if pgrep -x "wofi" > /dev/null;then
	exit 0
fi

# Launch
wofi "$@" &
