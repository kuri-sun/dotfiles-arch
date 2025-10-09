#!/bin/bash

# Post-installation configuration script
# Run with: bash post-install.sh

set -e

echo "========================================"
echo "Post-Installation Configuration"
echo "========================================"
echo ""

# Set zsh as default shell
echo "Setting zsh as default shell..."
if [[ "$SHELL" != "/bin/zsh" ]] && [[ "$SHELL" != "/usr/bin/zsh" ]]; then
    chsh -s /bin/zsh
    echo "✓ Zsh set as default shell (will take effect after logout/reboot)"
else
    echo "✓ Zsh is already the default shell"
fi
echo ""

# Enable NetworkManager
echo "Enabling NetworkManager..."
if systemctl is-enabled NetworkManager &> /dev/null; then
    echo "✓ NetworkManager is already enabled"
else
    sudo systemctl enable NetworkManager
    echo "✓ NetworkManager enabled"
fi

if systemctl is-active NetworkManager &> /dev/null; then
    echo "✓ NetworkManager is already running"
else
    sudo systemctl start NetworkManager
    echo "✓ NetworkManager started"
fi
echo ""

# Enable and configure firewall
echo "Configuring firewall (UFW)..."
if systemctl is-enabled ufw &> /dev/null; then
    echo "✓ UFW is already enabled"
else
    sudo systemctl enable ufw
    echo "✓ UFW enabled"
fi

if sudo ufw status | grep -q "Status: active"; then
    echo "✓ UFW is already active"
else
    sudo ufw enable
    echo "✓ UFW activated"
fi
echo ""

echo "========================================"
echo "Post-Installation Complete!"
echo "========================================"
echo ""
echo "Configuration summary:"
echo "  ✓ Zsh set as default shell"
echo "  ✓ NetworkManager enabled and running"
echo "  ✓ Firewall (UFW) enabled and active"
echo ""
read -p "Would you like to reboot now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Rebooting system..."
    sleep 2
    reboot
else
    echo "Please reboot your system later to apply all changes."
fi
