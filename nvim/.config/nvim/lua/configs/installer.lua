local M = {}

function M.install_formatters()
  -- Node.js formatters
  if vim.fn.executable("prettier") == 0 then
    vim.notify("Installing Node.js formatters...", vim.log.levels.INFO)
    -- Using vim.fn.system() is generally safer/better than os.execute()
    vim.fn.system("npm install -g prettier prettierd eslint_d @prettier/sql")
  end

  -- Go formatters
  if vim.fn.executable("gofumpt") == 0 then
    vim.notify("Installing Go formatters...", vim.log.levels.INFO)
    vim.fn.system("go install mvdan.cc/gofumpt@latest")
    vim.fn.system("go install golang.org/x/tools/cmd/goimports@latest")
  end

  -- Python formatters
  if vim.fn.executable("black") == 0 then
    vim.notify("Installing Python formatters...", vim.log.levels.INFO)
    vim.fn.system("pip install black ruff")
  end
end

-- Return the module table
return M
