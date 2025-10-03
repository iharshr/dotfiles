local M = {}

-- Mason bin path
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

-- Check if a command exists either in PATH or Mason
local function is_available(cmd)
  return vim.fn.executable(cmd) == 1 or vim.fn.filereadable(mason_bin .. "/" .. cmd) == 1
end

function M.install_formatters()
  -- Node.js formatters
  if not (is_available("prettier") and is_available("prettierd") and is_available("eslint_d")) then
    vim.notify("Installing Node.js formatters (npm)...", vim.log.levels.INFO)
    vim.fn.system("npm install -g prettier prettierd eslint_d @prettier/sql")
  end

  -- Go formatters
  if not (is_available("gofumpt") and is_available("goimports")) then
    vim.notify("Installing Go formatters (go)...", vim.log.levels.INFO)
    vim.fn.system("go install mvdan.cc/gofumpt@latest")
    vim.fn.system("go install golang.org/x/tools/cmd/goimports@latest")
  end

  -- Python formatters
  if not (is_available("black") and is_available("ruff")) then
    vim.notify("Installing Python formatters (pip)...", vim.log.levels.INFO)
    vim.fn.system("pip install --user black ruff")
  end
end

return M
