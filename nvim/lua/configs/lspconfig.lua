require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
-- Add JS, TS, Lua, Golang LSP support
local lspconfig = require("lspconfig")
lspconfig.tsserver.setup {}
lspconfig.lua_ls.setup {}
lspconfig.gopls.setup {}
lspconfig.gotests.setup {}
lspconfig.impl.setup {}
lspconfig.goplay.setup {}
lspconfig.dlv.setup {}
lspconfig.staticcheck.setup {}
