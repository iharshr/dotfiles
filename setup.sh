#!/usr/bin/env bash
set -euo pipefail

# Detect username for home-manager config
USER_NAME=$(whoami)

# 1. Install Nix (multi-user recommended for Ubuntu/Docker)
if ! command -v nix &>/dev/null; then
  echo "⬇️ Installing Nix..."
  sh <(curl -L https://nixos.org/nix/install) --daemon
  . /etc/profile.d/nix.sh
else
  echo "✅ Nix already installed"
fi

# 2. Enable flakes
mkdir -p "$HOME/.config/nix"
if ! grep -q "flakes" "$HOME/.config/nix/nix.conf" 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"
fi

# 3. Install Home Manager (flake style)
if ! command -v home-manager &>/dev/null; then
  echo "⬇️ Installing Home Manager..."
  nix run home-manager/master -- init --switch
fi

# 4. Apply Home Manager config
# Requires your flake.nix to define `homeConfigurations.${USER_NAME}`
if [ -f "$PWD/flake.nix" ]; then
  echo "🔧 Applying Home Manager config for $USER_NAME..."
  home-manager switch --flake "$PWD#$USER_NAME"
else
  echo "⚠️ No flake.nix found, falling back to plain home.nix"
  home-manager switch -f "$PWD/home.nix"
fi

# 5. Ensure GNU Stow is available
if ! command -v stow &>/dev/null; then
  echo "⬇️ Installing GNU Stow..."
  sudo apt-get update && sudo apt-get install -y stow
fi

# 6. Symlink dotfiles
for dir in zsh nvim; do
  if [ -d "$dir" ]; then
    stow -v -d "$PWD" -t "$HOME" "$dir"
  fi
done

echo "✅ Setup complete!"
