local M = {}

M.formatters_by_ft = {
  lua = { "stylua" },
  css = { "prettier" },
  html = { "prettier" },
  javascript = { "prettierd" },
  typescript = { "prettierd" },
  json = { "prettier" },
  python = { "black" },
  go = { "gofumpt" },
  sh = { "shfmt" },
  markdown = { "markdownlint" },
}

-- Optional: auto-format on save
M.format_on_save = {
  timeout_ms = 500,
  lsp_fallback = true,
}

return M
