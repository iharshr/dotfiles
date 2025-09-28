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
  home-manager switch --flake .#$(whoami);
else
  echo "⚠️ No flake.nix found, falling back to plain home.nix"
  home-manager switch -f "$PWD/home.nix"
fi

# 5. Ensure GNU Stow is available
if ! command -v stow &>/dev/null; then
  echo "⬇️ Installing GNU Stow..."
  sudo apt-get update && sudo apt-get install -y stow
fi

# Ensure Oh-My-Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "⬇️ Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Set custom plugin directory
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Clone required plugins if missing
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
[ -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ] || git clone https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete



# 6. Symlink dotfiles
for dir in zsh nvim; do
  [ -d "$dir" ] && stow --adopt -v -d "$PWD" -t "$HOME" "$dir"
done


echo "✅ Setup complete!"
