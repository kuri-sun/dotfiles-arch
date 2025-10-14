#!/bin/bash

# Get current fcitx5 input method
current=$(fcitx5-remote -n 2>/dev/null)

if [[ -z "$current" ]]; then
    echo "A"
    exit 0
fi

# Map input method to display text
case "$current" in
    *keyboard-us*|*"keyboard-en"*)
        echo "A"
        ;;
    *mozc*|*anthy*|*kkc*|*skk*|*japanese*)
        echo "あ"
        ;;
    *)
        echo "A"
        ;;
esac
