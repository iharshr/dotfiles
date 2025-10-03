-- Keymaps configuration
-- Helper
local map = vim.keymap.set

-------------------------------------------------------
-- General
-------------------------------------------------------
map("n", ";", ":", { desc = "Enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Save file (works in normal, insert, visual modes)
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-------------------------------------------------------
-- LSP / Formatting
-------------------------------------------------------
map("n", "<leader>ff", function()
  vim.lsp.buf.format { async = true }
end, { desc = "Format current buffer" })

-------------------------------------------------------
-- File Explorer (nvim-tree)
-------------------------------------------------------
map("n", "<leader>ee", function()
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then
    api.tree.toggle()
  else
    vim.notify("nvim-tree not available (check plugin status)", vim.log.levels.WARN)
  end
end, { desc = "Toggle file explorer" })

-------------------------------------------------------
-- Terminals (toggleterm.nvim)
-------------------------------------------------------
-- Terminals (toggleterm.nvim)
local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
  return
end

local Terminal = require("toggleterm.terminal").Terminal

toggleterm.setup {
  size = 15,
  open_mapping = [[<c-\>]],
  shade_terminals = true,
  shading_factor = 2,
  direction = "horizontal",
  float_opts = { border = "curved" },
}

-- Helper: create terminals with direction + index
local function get_term(direction, id)
  return Terminal:new({
    direction = direction,
    id = id,
    hidden = true,
  })
end

-- Bottom terminals
map("n", "<leader>tbn", function() get_term("horizontal"):toggle() end, { desc = "New bottom terminal" })
map("n", "<leader>tb", function() get_term("horizontal", 1):toggle() end, { desc = "Toggle bottom terminal" })
map("n", "<leader>tb1", function() get_term("horizontal", 1):toggle() end, { desc = "Bottom terminal 1" })
map("n", "<leader>tb2", function() get_term("horizontal", 2):toggle() end, { desc = "Bottom terminal 2" })
map("n", "<leader>tb3", function() get_term("horizontal", 3):toggle() end, { desc = "Bottom terminal 3" })

-- Right terminals
map("n", "<leader>trn", function() get_term("vertical"):toggle() end, { desc = "New right terminal" })
map("n", "<leader>tr", function() get_term("vertical", 1):toggle() end, { desc = "Toggle right terminal" })
map("n", "<leader>tr1", function() get_term("vertical", 1):toggle() end, { desc = "Right terminal 1" })
map("n", "<leader>tr2", function() get_term("vertical", 2):toggle() end, { desc = "Right terminal 2" })
map("n", "<leader>tr3", function() get_term("vertical", 3):toggle() end, { desc = "Right terminal 3" })

-- Floating terminals
map("n", "<leader>tfn", function() get_term("float"):toggle() end, { desc = "New floating terminal" })
map("n", "<leader>tf", function() get_term("float", 1):toggle() end, { desc = "Show floating terminal" })
map("n", "<leader>tfh", function() get_term("float", 1):close() end, { desc = "Hide floating terminal" })

-- Close all terminals
map("n", "<leader>tc", function() require("toggleterm").close_all() end, { desc = "Close all terminals" })

-- Send command to terminal
map("n", "<leader>ts", function()
  local cmd = vim.fn.input("Send to terminal: ")
  if cmd ~= "" then
    local term = get_term("horizontal", 1)
    term:toggle()
    term:send(cmd)
  end
end, { desc = "Send command to bottom terminal 1" })
