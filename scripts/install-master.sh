#!/bin/bash

# Master installation script for complete system setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================"
echo "Complete System Setup"
echo "========================================"
echo ""
echo "This script will perform the following:"
echo "  1. Install all official Arch packages (74 packages)"
echo "  2. Install all AUR packages (yay, paru, google-chrome)"
echo "  3. Configure system settings (zsh, oh-my-zsh, NetworkManager, firewall)"
echo ""
echo "Your configuration files should already be in ~/.config/"
echo ""
read -p "Continue with complete installation? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Installation cancelled."
  exit 0
fi

echo ""
echo "========================================"
echo "Step 1: Installing Official Packages"
echo "========================================"
# Installs all packages from pkglist.txt using pacman
bash "$SCRIPT_DIR/install-official-packages.sh"

echo ""
echo "========================================"
echo "Step 2: Installing AUR Packages"
echo "========================================"
# Installs all packages from aurlist.txt using yay/paru
# Will automatically install yay if no AUR helper is found
bash "$SCRIPT_DIR/install-aur-packages.sh"

echo ""
echo "========================================"
echo "Step 3: Post-Installation Configuration"
echo "========================================"
# Sets up zsh, oh-my-zsh, NetworkManager, and firewall
# Offers to reboot the system
bash "$SCRIPT_DIR/post-install.sh"

echo ""
echo "========================================"
echo "Installation Complete!"
echo "========================================"
echo ""
echo "Your system is now fully configured with:"
echo "  ✓ All packages installed"
echo "  ✓ Configuration files in place"
echo "  ✓ System services enabled"
echo ""
echo "Enjoy your Hyprland Yoda setup!"
echo ""
