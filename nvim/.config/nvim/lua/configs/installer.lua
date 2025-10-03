local M = {}

-- Helper function to check if a command exists
local function is_executable(cmd)
  return vim.fn.executable(cmd) == 1
end

function M.install_formatters()
  -- Node.js formatters
  if not is_executable("prettier") or not is_executable("eslint_d") or not is_executable("prettierd") or not is_executable("prettier-sql") then
    vim.notify("Installing Node.js formatters...", vim.log.levels.INFO)
    vim.fn.system("npm install -g prettier prettierd eslint_d @prettier/sql")
  end

  -- Go formatters
  if not is_executable("gofumpt") or not is_executable("goimports") then
    vim.notify("Installing Go formatters...", vim.log.levels.INFO)
    vim.fn.system("go install mvdan.cc/gofumpt@latest")
    vim.fn.system("go install golang.org/x/tools/cmd/goimports@latest")
  end

  -- Python formatters
  if not is_executable("black") or not is_executable("ruff") then
    vim.notify("Installing Python formatters...", vim.log.levels.INFO)
    vim.fn.system("pip install --user black ruff")
  end
end

return M
