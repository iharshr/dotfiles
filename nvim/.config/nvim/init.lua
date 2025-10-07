-- Prioritize Nix binaries over Mason binaries
vim.env.PATH = vim.env.HOME .. "/.nix-profile/bin:" .. vim.env.PATH

-- Add Mason bin so plugins like Conform see installed binaries
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not string.find(vim.env.PATH, mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                   lazypath})
end
vim.opt.rtp:prepend(lazypath)
vim.opt.clipboard = "unnamedplus"
-- Lazy.nvim setup
require("lazy").setup({ -- NvChad core
{
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins"
}, -- custom plugins
{
    import = "plugins"
}}, {
    -- lazy.nvim config options
    install = {
        colorscheme = {"catppuccin", "tokyonight"}
    },
    checker = {
        enabled = true
    },
    defaults = {
        lazy = true,
        version = "*"
    }
})

-- options, autocmds, mappings
require("options")
require("autocmds")

-- Load mappings after a delay to ensure everything is loaded
vim.schedule(function()
    require("mappings")
end)
