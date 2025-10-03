-- Lua files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.lua",
  callback = function()
    vim.bo.filetype = "lua"
  end,
})

-- Optional: force filetype for init.lua
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "init.lua",
  callback = function()
    vim.bo.filetype = "lua"
  end,
})

-- You can add more filetype fixes here if needed
-- Example:
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = "*.myext",
--   callback = function()
--     vim.bo.filetype = "myfiletype"
--   end,
-- })
