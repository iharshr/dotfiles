return { -- Formatter/Code actions
{
    "stevearc/conform.nvim",
    lazy = true,
    event = "BufWritePre",
    opts = require("configs.conform")
}, -- LSPConfig core
{
    "neovim/nvim-lspconfig",
    lazy = true,
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim"},
    config = function()
        require("configs.lspconfig")
    end
}, -- Mason package manager
{
    "williamboman/mason.nvim",
    cmd = {"Mason", "MasonInstall", "MasonUpdate"},
    opts = {
        -- optional: default settings
        ui = {
            border = "rounded"
        }
    }
}, -- Mason LSPConfig bridge
{
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    event = {"BufReadPre", "BufNewFile"},
    opts = {
        ensure_installed = {"typescript-language-server", "eslint-lsp", "jsonls", "yamlls", "dockerls",
                            "graphql-language-service-cli", "prisma-language-server", "gopls", "go-staticcheck",
                            "golangci-lint", "pyright", "ruff-lsp", "html", "cssls", "emmet-ls",
                            "tailwindcss-language-server", "markdownlint", "prettier", "stylua", "black", "shfmt",
                            "biome"},
        automatic_installation = true
    }
}, -- Autopairs
{
    "windwp/nvim-autopairs",
    event = "InsertEnter", -- Load only when entering Insert mode
    config = true -- Runs require("nvim-autopairs").setup{}
}}
