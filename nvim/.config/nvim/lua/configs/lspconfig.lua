-- Ensure Neovim sees Nix binaries
vim.env.PATH = vim.env.HOME .. "/.nix-profile/bin:" .. vim.env.PATH

local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Filetype mappings for JSX/TSX
vim.filetype.add({
    extension = {
        tsx = "typescriptreact",
        jsx = "javascriptreact"
    }
})

-- Common on_attach function for all LSPs
local on_attach = function(client, bufnr)
    local bufopts = {
        noremap = true,
        silent = true,
        buffer = bufnr
    }

    -- Disable formatting for all LSPs (use Prettier/Conform instead)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- LSP Keymaps
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)

    -- Autocompletion trigger characters
    if client.server_capabilities.completionProvider then
        client.server_capabilities.completionProvider.triggerCharacters = {".", ":", ">", "/", "<", "'", '"'}
    end
end

-- Default capabilities
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Mason LSP setup
mason_lspconfig.setup({
    ensure_installed = {"lua_ls", "typescript-language-server", "eslint-lsp", "jsonls", "yamlls", "html", "cssls",
                        "pyright", "gopls"},
    handlers = {
        -- Default handler for all Mason-installed LSPs
        function(server_name)
            lspconfig[server_name].setup({
                capabilities = capabilities,
                on_attach = on_attach
            })
        end,

        -- Lua LSP (lua_ls)
        ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT"
                        },
                        diagnostics = {
                            globals = {"vim"}
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false
                        },
                        telemetry = {
                            enable = false
                        }
                    }
                }
            })
        end,

        -- ESLint
        ["eslint"] = function()
            lspconfig.eslint.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    validate = "on",
                    format = {
                        enable = true
                    }
                }
            })
        end,

        -- HTML with Emmet support
        ["html"] = function()
            lspconfig.html.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = {"vscode-html-language-server", "--stdio"},
                settings = {
                    html = {
                        suggest = {
                            html5 = true
                        }
                    }
                }
            })
        end,

        -- Biome LSP
        ["biome"] = function()
            lspconfig.biome.setup({
                cmd = {"biome", "lsp-proxy"},
                filetypes = {"javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc"},
                root_dir = lspconfig.util.root_pattern("package.json", ".git"),
                capabilities = capabilities,
                on_attach = on_attach
            })
        end
    }
})
