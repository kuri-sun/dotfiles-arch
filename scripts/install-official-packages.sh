#!/bin/bash

# Script to install official Arch packages from pkglist.txt
# Run with: bash install-official-packages.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKGLIST="$SCRIPT_DIR/pkglist.txt"

echo "========================================"
echo "Installing Official Arch Packages"
echo "========================================"

if [[ ! -f "$PKGLIST" ]]; then
    echo "Error: pkglist.txt not found at $PKGLIST"
    exit 1
fi

# Read packages from file, filter out empty lines
PACKAGES=$(grep -v '^$' "$PKGLIST" | tr '\n' ' ')

if [[ -z "$PACKAGES" ]]; then
    echo "No packages found in pkglist.txt"
    exit 0
fi

echo "Packages to install:"
echo "$PACKAGES"
echo ""
echo "Updating package database..."
sudo pacman -Sy

echo ""
echo "Installing packages..."
# --needed flag skips packages that are already up to date
# --noconfirm flag to avoid prompts (remove if you want confirmation)
sudo pacman -S --needed $PACKAGES

echo ""
echo "========================================"
echo "Official packages installation complete!"
echo "========================================"
