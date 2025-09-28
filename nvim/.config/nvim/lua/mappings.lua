local map = vim.keymap.set

-- Basic keymaps
map("n", ";", ":", { desc = "Enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Save file (works in normal, insert, visual modes)
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })

-- Format current buffer using LSP
map("n", "<leader>ff", function()
  vim.lsp.buf.format { async = true }
end, { desc = "Format file" })

-- Toggle file explorer (FIXED: using nvim-tree.api)
map("n", "<leader>ee", function()
  -- Check if nvim-tree is installed (optional, but good practice)
  local ok, api = pcall(require, "nvim-tree.api") 
  
  if ok then
    api.tree.toggle()
  else
    vim.notify("nvim-tree not available (check plugin status)", vim.log.levels.WARN)
  end
end, { desc = "Toggle file tree" })
