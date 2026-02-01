#!/bin/bash
set -e

echo "==> Bootstrapping dotfiles..."

# Install Xcode Command Line Tools (if not present)
if ! xcode-select -p &>/dev/null; then
  echo "==> Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "    Waiting for installation to complete..."
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  echo "    Done."
fi

# Install Homebrew (if not present)
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is in PATH for this session (Apple Silicon path)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
# Intel Mac path
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Run the main setup
echo "==> Running make setup..."
make setup

echo "==> Bootstrap complete!"
