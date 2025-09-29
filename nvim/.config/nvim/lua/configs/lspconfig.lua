-- lua/configs/lspconfig.lua
-- Ensure Neovim sees Nix binaries
vim.env.PATH = vim.env.HOME .. "/.nix-profile/bin:" .. vim.env.PATH

local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
require("configs.codebook")

-- Filetype mappings for JSX/TSX
vim.filetype.add({
    extension = {
        tsx = "typescriptreact",
        jsx = "javascriptreact",
    }
})

-- Common on_attach function for all LSPs
local on_attach = function(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- Disable formatting for all LSPs (use Prettier/Conform instead)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- Jump to definition
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)

    -- Autocompletion trigger characters
    if client.server_capabilities.completionProvider then
        client.server_capabilities.completionProvider.triggerCharacters = {".", ":", ">", "/", "<", "'", '"'}
    end
end

-- Mason LSP setup
mason_lspconfig.setup({
    ensure_installed = {},
    handlers = {
        -- Default handler for all Mason-installed LSPs
        function(server_name)
            lspconfig[server_name].setup({
                capabilities = cmp_nvim_lsp.default_capabilities(),
                on_attach = on_attach
            })
        end,

        -- ESLint
        ["eslint"] = function()
            lspconfig.eslint.setup({
                capabilities = cmp_nvim_lsp.default_capabilities(),
                on_attach = on_attach,
                settings = {
                    validate = "on",
                    format = { enable = true } -- ESLint fixes on save if enabled
                }
            })
        end,

        -- HTML with Emmet support
        ["html"] = function()
            lspconfig.html.setup({
                capabilities = cmp_nvim_lsp.default_capabilities(),
                on_attach = on_attach,
                cmd = { "vscode-html-language-server", "--stdio" },
                settings = {
                    html = { suggest = { html5 = true } }
                }
            })
        end,

        -- Biome LSP (JS/TS/React) — LSP only, no formatting/linting
        ["biome"] = function()
            lspconfig.biome.setup({
                cmd = { "biome", "lsp-proxy" },
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
                root_dir = lspconfig.util.root_pattern("package.json", ".git"),
                capabilities = cmp_nvim_lsp.default_capabilities(),
                on_attach = on_attach
            })
        end,
    }
})
