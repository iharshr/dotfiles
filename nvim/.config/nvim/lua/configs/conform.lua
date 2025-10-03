local js_ts = {"prettierd", "prettier", stop_after_first = true}

local M = {}

-- Formatters configuration
M.formatters_by_ft = {
    lua = {"stylua"},
    css = {"prettier"},
    html = {"prettier"},
    javascript = js_ts,
    javascriptreact = js_ts,
    typescript = js_ts,
    typescriptreact = js_ts,
    json = {"prettier"},
    python = {"black"},
    go = {"gofumpt"},
    sh = {"shfmt"},
    markdown = {"prettier"}
}

-- Optional: auto-format on save
M.format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true
}

-- Ensure we use Nix-installed formatters by checking their paths
M.formatters = {
    stylua = {
        command = vim.fn.exepath("stylua") ~= "" and vim.fn.exepath("stylua") or "stylua",
    },
    prettier = {
        command = vim.fn.exepath("prettier") ~= "" and vim.fn.exepath("prettier") or "prettier",
    },
    prettierd = {
        command = vim.fn.exepath("prettierd") ~= "" and vim.fn.exepath("prettierd") or "prettierd",
    },
    black = {
        command = vim.fn.exepath("black") ~= "" and vim.fn.exepath("black") or "black",
    },
    gofumpt = {
        command = vim.fn.exepath("gofumpt") ~= "" and vim.fn.exepath("gofumpt") or "gofumpt",
    },
    shfmt = {
        command = vim.fn.exepath("shfmt") ~= "" and vim.fn.exepath("shfmt") or "shfmt",
    },
}

return M
