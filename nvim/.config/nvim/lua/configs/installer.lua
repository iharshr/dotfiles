local M = {}

-- Flag file to track if installation has been attempted
local install_flag = vim.fn.stdpath("data") .. "/.formatters_installed"

-- Check if a command exists in PATH (including Mason bin)
local function is_available(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Check if all formatters are available
local function all_formatters_available()
  local formatters = {
    -- Node.js formatters
    "prettier",
    "prettierd",
    "eslint_d",
    -- Go formatters
    "gofumpt",
    "goimports",
    -- Python formatters
    "black",
    "ruff"
  }
  
  for _, formatter in ipairs(formatters) do
    if not is_available(formatter) then
      return false
    end
  end
  
  return true
end

function M.install_formatters()
  -- Check if we've already attempted installation
  if vim.fn.filereadable(install_flag) == 1 then
    return
  end
  
  -- Check if all formatters are already available
  if all_formatters_available() then
    -- Create flag file to prevent future checks
    vim.fn.writefile({}, install_flag)
    return
  end
  
  -- Only install missing formatters
  local installed_any = false
  
  -- Node.js formatters
  if not (is_available("prettier") and is_available("prettierd") and is_available("eslint_d")) then
    vim.notify("Installing Node.js formatters (npm)...", vim.log.levels.INFO)
    vim.fn.system("npm install -g prettier prettierd eslint_d")
    installed_any = true
  end

  -- Go formatters
  if not (is_available("gofumpt") and is_available("goimports")) then
    vim.notify("Installing Go formatters (go)...", vim.log.levels.INFO)
    vim.fn.system("go install mvdan.cc/gofumpt@latest")
    vim.fn.system("go install golang.org/x/tools/cmd/goimports@latest")
    installed_any = true
  end

  -- Python formatters
  if not (is_available("black") and is_available("ruff")) then
    vim.notify("Installing Python formatters (pip)...", vim.log.levels.INFO)
    vim.fn.system("pip install --user black ruff")
    installed_any = true
  end
  
  -- Create flag file after installation attempt
  vim.fn.writefile({}, install_flag)
  
  if installed_any then
    vim.notify("Formatter installation complete. Restart Neovim to use them.", vim.log.levels.INFO)
  end
end

-- Command to force reinstall formatters
vim.api.nvim_create_user_command("FormattersReinstall", function()
  -- Remove flag file
  vim.fn.delete(install_flag)
  -- Run installation
  M.install_formatters()
end, { desc = "Force reinstall formatters" })

return M
