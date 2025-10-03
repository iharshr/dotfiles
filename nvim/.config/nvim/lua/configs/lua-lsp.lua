-- Lua LSP configuration (lua_ls)
local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT", -- Neovim uses LuaJIT
      },
      diagnostics = {
        globals = { "vim" }, -- recognize `vim` global
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false, -- avoid annoying prompts
      },
      telemetry = {
        enable = false, -- disable telemetry
      },
    },
  },
})
