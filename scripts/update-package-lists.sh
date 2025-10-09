#!/bin/bash

# Script to update package lists
# This regenerates pkglist.txt and aurlist.txt based on currently installed packages

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo "Updating Package Lists"
echo "========================================"

# Update official packages list
echo "Updating pkglist.txt..."
pacman -Qqe | grep -v "$(pacman -Qqm)" > "$CONFIG_DIR/pkglist.txt"
OFFICIAL_COUNT=$(wc -l < "$CONFIG_DIR/pkglist.txt")
echo "✓ Saved $OFFICIAL_COUNT official packages to pkglist.txt"

# Update AUR packages list
echo "Updating aurlist.txt..."
pacman -Qqm > "$CONFIG_DIR/aurlist.txt"
AUR_COUNT=$(wc -l < "$CONFIG_DIR/aurlist.txt")
echo "✓ Saved $AUR_COUNT AUR packages to aurlist.txt"

echo ""
echo "========================================"
echo "Package lists updated successfully!"
echo "========================================"
