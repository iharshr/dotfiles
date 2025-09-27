return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- Only loads when saving files
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- Lazy-load on file operations
    config = function()
      require "configs.lspconfig"
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" }, -- Only loads when Mason commands are used
    opts = {
      ensure_installed = {
        -- LSP Servers (installed but not loaded until needed)
        "tsserver", "eslint-lsp", "json-lsp", "yaml-language-server", 
        "dockerfile-language-server", "graphql-language-service-cli", "prisma-language-server",
        "gopls", "golangci-lint-langserver", "staticcheck",
        "pyright", "ruff-lsp",
        "html-lsp", "css-lsp", "emmet-ls", "tailwindcss-language-server",
        
        -- Formatters
        "prettier", "prettierd", "stylua", "black", "shfmt", "markdownlint",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- Lazy-load with lspconfig
    opts = {
      ensure_installed = {
        "tsserver", "eslint", "jsonls", "yamlls", "dockerls", "graphql", "prismals",
        "gopls", "golangci_lint_ls", "staticcheck",
        "pyright", "ruff_lsp",
        "html", "cssls", "emmet_ls", "tailwindcss"
      },
      automatic_installation = true,
    },
  },
}
