require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- <leader>ff to format file
map("n", "<leader>ff", function()
  vim.lsp.buf.format { async = true }
end, { desc = "Format file" })

-- <leader>ee to toggle file tree (NvTreeToggle)
map("n", "<leader>ee", function()
  require("nvchad.tree").toggle()
end, { desc = "Toggle file tree" })
