**This repo is supposed to be used as config by NvChad users!**

- The main NvChad repo (NvChad/NvChad) is used as a plugin by this repo.
- You can import its modules like `require "nvchad.options"`, `require "nvchad.mappings"`, etc.
- You can delete the `.git` from this repo (when you clone it locally) or fork it :)

## File Structure Overview

Here's what each file does in this configuration:

### Root Level Files
- **`README.md`** – This file! Explains the repo structure and usage.
- **`init.lua`** – The main entry point for Neovim. Bootstraps lazy.nvim and loads plugins, themes, options, and mappings.
- **`.stylua.toml`** – Configuration for the Stylua formatter (used for formatting Lua files).

### Lua Configuration Files
- **`autocmds.lua`** – Loads NvChad's default autocommands (filetype detection, etc.).
- **`chadrc.lua`** – Customizes NvChad's UI and behavior (themes, statusline, etc.). Based on `nvconfig.lua` from NvChad.
- **`mappings.lua`** – Defines key mappings. Includes NvChad's defaults and allows adding custom mappings.
- **`options.lua`** – Sets Neovim options. Extends NvChad's default options with user preferences.

### Configs Directory (`lua/configs/`)
- **`lazy.lua`** – Configuration for lazy.nvim (plugin manager). Defines lazy defaults, UI icons, and disabled plugins.
- **`conform.lua`** – Configures Conform.nvim for code formatting. Defines formatters per filetype (e.g., Stylua for Lua).
- **`lspconfig.lua`** – Configures LSP servers (e.g., tsserver, lua_ls, gopls). Extends NvChad's LSP defaults.

### Plugins Directory (`lua/plugins/`)
- **`init.lua`** – Lists and configures additional plugins (e.g., conform.nvim, nvim-lspconfig). Can include Treesitter, etc.

## Usage
1. Clone this repo to your Neovim config directory (usually `~/.config/nvim/`).
2. Customize files like `chadrc.lua`, `mappings.lua`, and `options.lua` to suit your needs.
3. Add or modify plugins in `lua/plugins/init.lua`.
4. Use `:Lazy` to manage plugins and `:Mason` to install LSP servers, linters, and formatters.

## Credits
1) LazyVim starter: https://github.com/LazyVim/starter – NvChad's starter was inspired by LazyVim and made many things easier!
