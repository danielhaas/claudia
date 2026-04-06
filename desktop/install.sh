#!/usr/bin/env bash
# Install claudia desktop components
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/claudia"

echo "=== Claudia Desktop Install ==="

# Create directories
mkdir -p "$INSTALL_DIR" "$CONFIG_DIR"

# Install claudia-manager
cp "$SCRIPT_DIR/claudia-manager" "$INSTALL_DIR/claudia-manager"
chmod +x "$INSTALL_DIR/claudia-manager"
echo "[ok] Installed claudia-manager to $INSTALL_DIR/"

# Install tmux config
cp "$SCRIPT_DIR/claudia.tmux.conf" "$CONFIG_DIR/tmux.conf"
echo "[ok] Installed tmux config to $CONFIG_DIR/tmux.conf"

# Check if ~/.local/bin is in PATH
if ! echo "$PATH" | tr ':' '\n' | grep -q "${HOME}/.local/bin"; then
    echo ""
    echo "[!!] ${HOME}/.local/bin is not in your PATH."
    echo "     Add this to your ~/.bashrc or ~/.zshrc:"
    echo "     export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# Set up shell alias
ALIAS_LINE='alias claude="claudia-manager wrap"'
ALIAS_COMMENT="# claudia: auto-wrap claude in tmux sessions"

setup_shell_alias() {
    local rc_file="$1"
    if [[ -f "$rc_file" ]]; then
        if grep -q "claudia-manager wrap" "$rc_file" 2>/dev/null; then
            echo "[ok] Shell alias already in $rc_file"
        else
            echo "" >> "$rc_file"
            echo "$ALIAS_COMMENT" >> "$rc_file"
            echo "$ALIAS_LINE" >> "$rc_file"
            echo "[ok] Added claude alias to $rc_file"
        fi
    fi
}

# Detect shell and add alias
if [[ -f "${HOME}/.bashrc" ]]; then
    setup_shell_alias "${HOME}/.bashrc"
fi
if [[ -f "${HOME}/.zshrc" ]]; then
    setup_shell_alias "${HOME}/.zshrc"
fi

echo ""
echo "Done! Restart your shell or run: source ~/.bashrc"
echo ""
echo "Now when you run 'claude', it will auto-launch inside a tmux session."
echo "These sessions are accessible from your phone via the 'cc' command."
