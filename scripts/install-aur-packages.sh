#!/bin/bash

# Script to install AUR packages from aurlist.txt
# Run with: bash install-aur-packages.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AURLIST="$SCRIPT_DIR/aurlist.txt"

echo "========================================"
echo "Installing AUR Packages"
echo "========================================"

if [[ ! -f "$AURLIST" ]]; then
    echo "Error: aurlist.txt not found at $AURLIST"
    exit 1
fi

# Read packages from file, filter out empty lines
PACKAGES=$(grep -v '^$' "$AURLIST" | tr '\n' ' ')

if [[ -z "$PACKAGES" ]]; then
    echo "No packages found in aurlist.txt"
    exit 0
fi

# Check if an AUR helper is installed
AUR_HELPER=""
if command -v yay &> /dev/null; then
    AUR_HELPER="yay"
elif command -v paru &> /dev/null; then
    AUR_HELPER="paru"
else
    echo "Error: No AUR helper found!"
    echo "Installing yay first..."

    # Install yay if not present
    cd /tmp
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay

    AUR_HELPER="yay"
fi

echo "Using AUR helper: $AUR_HELPER"
echo ""
echo "Packages to install:"
echo "$PACKAGES"
echo ""

# Install AUR packages
# --needed flag skips packages that are already up to date
$AUR_HELPER -S --needed $PACKAGES

echo ""
echo "========================================"
echo "AUR packages installation complete!"
echo "========================================"
