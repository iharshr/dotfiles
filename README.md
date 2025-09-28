# dotfiles

## Overview

A fully reproducible Ubuntu developer environment using **Nix + Home Manager**, GNU Stow, and a single `setup.sh` bootstrap script.

This setup installs all required packages, configures your shell and Neovim, and symlinks dotfiles so you can recreate your environment on any machine.

---

## Directory Structure

```
dotfiles/
  zsh/.zshrc         # Zsh configuration
  nvim/init.lua      # Neovim / NvChad overrides
  home.nix           # Home Manager config (packages + programs)
  flake.nix          # Flake definition (optional, modern way)
  setup.sh           # Bootstrap script
```

---

## Usage

1. **Clone this repo**

   ```sh
   git clone https://github.com/iharshr/dotfiles.git
   cd dotfiles
   ```

2. **Run the setup script**

   ```sh
   ./setup.sh
   ```

   This will:

   * Install **Nix** (multi-user mode)
   * Enable **Home Manager**
   * Apply your `home.nix` configuration (packages + shell + Neovim)
   * Install **GNU Stow**
   * Symlink dotfiles (`zsh/`, `nvim/`) into `$HOME`

---

## Dotfile Management with Stow

Stow works by creating **symlinks** from your repo into `$HOME`.
Once linked, editing files in the repo updates your live config immediately.

### Initial linking

```sh
stow -v -d "$PWD" -t "$HOME" zsh
stow -v -d "$PWD" -t "$HOME" nvim
```

This creates links like:

```
~/.zshrc  → dotfiles/zsh/.zshrc
~/.config/nvim/init.lua → dotfiles/nvim/init.lua
```

### Editing configs

* If you edit `dotfiles/nvim/init.lua` (your NvChad override), the changes appear instantly in `~/.config/nvim/init.lua` because it’s the same file via symlink.
* Same with `dotfiles/zsh/.zshrc` → `~/.zshrc`.

No extra Stow step needed for edits.

### Adding new files

If you add a new file (e.g., `dotfiles/nvim/lua/custom/keymaps.lua`), run Stow again:

```sh
stow -v -d "$PWD" -t "$HOME" nvim
```

### Removing files

If you delete or want to remove symlinks:

```sh
stow -D -v -d "$PWD" -t "$HOME" nvim
```

---

## Configuration Management with Home Manager

Home Manager tracks generations of your configuration, similar to Git commits.
You can **enable**, **disable**, or **revert** packages and programs declaratively.

### ✅ Enable a package

Edit `home.nix`:

```nix
home.packages = with pkgs; [
  neovim
  git
  htop   # added
];
```

Apply:

```sh
home-manager switch --flake .#harsh
home-manager switch --flake .#$(whoami);
```

### ❌ Disable a package

Remove/comment it in `home.nix`, then reapply.

### ↩️ Revert a generation

```sh
home-manager generations
home-manager rollback
```

---

## Customization

* Edit `zsh/.zshrc` for shell config and plugins
* Edit `nvim/init.lua` for Neovim/NvChad overrides
* Edit `home.nix` to add/remove packages
* Flake users can pin versions in `flake.nix`

---

## Requirements

* Ubuntu (tested on 22.04+)
* Bash or Zsh
* Git

---

## Troubleshooting

* If you encounter issues, check the output of `setup.sh` for errors.
* For Nix/Home Manager issues:

  * [Nix Manual](https://nixos.org/manual.html)
  * [Home Manager Manual](https://nix-community.github.io/home-manager/)

---

## Notes

* By default, `home.nix` installs **Go, Node.js, Python, Zsh, Neovim, Docker, Git, and related tooling** directly via Nix.
* You **don’t need `gvm` or `nvm`** — versions are managed declaratively by Home Manager.
* **Edits to files in this repo update live configs immediately** thanks to Stow.
* **Re-running Stow** is only needed when adding or removing new files/directories.
