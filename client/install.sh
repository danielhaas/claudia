#!/usr/bin/env bash
# Install claudia mobile components (for Termux)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/claudia"

echo "=== Claudia Mobile Install ==="

# Create directories
mkdir -p "$INSTALL_DIR" "$CONFIG_DIR"

# Install claudia command
cp "$SCRIPT_DIR/claudia" "$INSTALL_DIR/claudia"
chmod +x "$INSTALL_DIR/claudia"
echo "[ok] Installed claudia to $INSTALL_DIR/"

# Check PATH
if ! echo "$PATH" | tr ':' '\n' | grep -q "${HOME}/.local/bin"; then
    echo ""
    echo "[!!] ${HOME}/.local/bin is not in your PATH."
    echo "     Add this to your shell config:"
    echo "     export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# Check for ssh
if ! command -v ssh &>/dev/null; then
    echo "[!!] ssh not found. Install openssh in Termux:"
    echo "     pkg install openssh"
fi

# Check for tailscale
if ! command -v tailscale &>/dev/null; then
    echo "[!!] tailscale CLI not found. Host discovery won't work."
    echo "     You can configure hosts manually in $CONFIG_DIR/mobile.conf"
fi

# Set up SSH key if none exists
if [[ ! -f "${HOME}/.ssh/id_ed25519" && ! -f "${HOME}/.ssh/id_rsa" ]]; then
    echo ""
    printf "No SSH key found. Generate one? [Y/n] "
    read -r answer
    if [[ "${answer:-Y}" =~ ^[Yy]$ ]]; then
        ssh-keygen -t ed25519 -f "${HOME}/.ssh/id_ed25519" -N ""
        echo "[ok] SSH key generated"
        echo ""
        echo "Copy this key to your desktops:"
        echo "  ssh-copy-id user@hostname"
    fi
fi

echo ""
echo "Done! Run 'claudia' to connect to your Claude sessions."
