require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

-- LSP servers configuration with filetype-based activation
local servers = {
  -- MERN/MEAN Stack
  tsserver = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  eslint = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  jsonls = { "json", "jsonc" },
  yamlls = { "yaml", "yml" },
  dockerls = { "dockerfile" },
  graphql = { "graphql", "gql" },
  prismals = { "prisma" },
  
  -- Golang Stack
  gopls = { "go", "gomod", "gowork" },
  golangci_lint_ls = { "go" },
  staticcheck = { "go" },
  
  -- Python Stack
  pyright = { "python" },
  ruff_lsp = { "python" },
  
  -- Web Technologies
  html = { "html" },
  cssls = { "css", "scss", "less" },
  emmet_ls = { "html", "css", "scss", "javascriptreact", "typescriptreact" },
  tailwindcss = { "html", "css", "scss", "javascriptreact", "typescriptreact" },
}

-- Auto-configure LSP servers with filetype detection
mason_lspconfig.setup_handlers({
  function(server_name)
    local filetypes = servers[server_name]
    if filetypes then
      lspconfig[server_name].setup({
        capabilities = require("nvchad.configs.lspconfig").capabilities,
        on_attach = require("nvchad.configs.lspconfig").on_attach,
        filetypes = filetypes, -- Lazy-load by filetype
        single_file_support = true,
      })
    end
  end,
})
