local M = {}

function M.install_formatters()
  -- Check if Node.js formatters are installed, if not install them
  local handle = io.popen("which prettier")
  local result = handle:read("*a")
  handle:close()
  
  if result == "" then
    print("Installing Node.js formatters...")
    os.execute("npm install -g prettier prettierd eslint_d @prettier/sql")
  end

  -- Check if Go formatters are installed
  handle = io.popen("which gofumpt")
  result = handle:read("*a")
  handle:close()
  
  if result == "" then
    print("Installing Go formatters...")
    os.execute("go install mvdan.cc/gofumpt@latest")
    os.execute("go install golang.org/x/tools/cmd/goimports@latest")
  end

  -- Check if Python formatters are installed
  handle = io.popen("which black")
  result = handle:read("*a")
  handle:close()
  
  if result == "" then
    print("Installing Python formatters...")
    os.execute("pip install black ruff")
  end
end

return M
