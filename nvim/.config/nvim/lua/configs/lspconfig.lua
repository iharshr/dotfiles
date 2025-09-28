-- lua/configs/lspconfig.lua
-- Recommended configuration using mason-lspconfig handlers (no manual loop needed)

local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Define a reusable function for common LSP setup (keymaps, formatting, etc.)
local on_attach = function(client, bufnr)
  -- Set common buffer-local keymaps here, e.g., for LSP features
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Example: Jump to definition
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  
  -- Example: Format file (uses the client's formatting capability)
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set("n", "<leader>ff", function()
      vim.lsp.buf.format { async = true }
    end, bufopts)
  end
  
  -- Enable autocompletion capabilities for your completion plugin (like nvim-cmp)
  if client.server_capabilities.completionProvider then
    client.server_capabilities.completionProvider.triggerCharacters = { ".", ":", ">", "/", "<", "'", '"' }
  end
end

-- Use mason-lspconfig.setup_handlers to automatically configure all installed LSPs.
mason_lspconfig.setup({
  -- NOTE: The list of servers to install (ensure_installed) should primarily be in your 
  -- plugins.lua file under the 'mason-lspconfig.nvim' spec. 
  -- Keeping it empty here relies on the list defined in your plugins.lua.
  ensure_installed = {},
  
  -- The 'handlers' block is the core of this modern setup.
  -- It defines how every installed server should be set up.
  handlers = {
    -- Default handler: Set up EVERY installed server with the standard config
    function(server_name)
      lspconfig[server_name].setup({
        capabilities = cmp_nvim_lsp.default_capabilities(),
        on_attach = on_attach,
      })
    end,
    
    -- You can add custom handlers for specific servers here if needed.
    -- Example for 'eslint', which often needs special settings:
    ["eslint"] = function()
      lspconfig.eslint.setup({
        capabilities = cmp_nvim_lsp.default_capabilities(),
        on_attach = on_attach,
        settings = {
          -- Example: Fixable problems will be auto-fixed on save
          validate = "on",
          format = { enable = true },
        },
      })
    end,

    -- Example for 'html', which should be configured with 'emmet-ls' as a dependency
    ["html"] = function()
        lspconfig.html.setup({
            capabilities = cmp_nvim_lsp.default_capabilities(),
            on_attach = on_attach,
            -- Add emmet-ls as a setup dependency
            cmd = { "vscode-html-language-server", "--stdio" }, 
            settings = {
                html = {
                    -- Emmet is often configured here
                    suggest = { html5 = true },
                },
            },
        })
    end,
  }
})

vim.lsp.enable('cookbook')
