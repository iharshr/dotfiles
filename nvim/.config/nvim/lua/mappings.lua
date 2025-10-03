-- Keymaps configuration
local map = vim.keymap.set

-------------------------------------------------------
-- General
-------------------------------------------------------
map("n", ";", ":", { desc = "Enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Save file
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Quit
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all (force)" })

-------------------------------------------------------
-- Window Management
-------------------------------------------------------
-- Split windows
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split vertically" })
map("n", "<leader>wh", "<cmd>split<cr>", { desc = "Split horizontally" })
map("n", "<leader>wc", "<cmd>close<cr>", { desc = "Close window" })
map("n", "<leader>wo", "<cmd>only<cr>", { desc = "Close other windows" })

-- Navigate windows
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

-- Equal window sizes
map("n", "<leader>we", "<C-w>=", { desc = "Equal window sizes" })

-------------------------------------------------------
-- Buffer/Tab Management
-------------------------------------------------------
-- Switch buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Delete buffer (force)" })

-- Tabs
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>c", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

-------------------------------------------------------
-- File Operations (using Oil.nvim)
-------------------------------------------------------
map("n", "<leader>o", "<cmd>Oil<cr>", { desc = "Open file manager" })

-- NvimTree (if you prefer)
map("n", "<leader>e", function()
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then
    api.tree.toggle()
  else
    vim.notify("nvim-tree not available", vim.log.levels.WARN)
  end
end, { desc = "Toggle file explorer" })

-------------------------------------------------------
-- Telescope (Fuzzy Finder)
-------------------------------------------------------
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg",
  function() require("telescope.builtin").live_grep({ additional_args = function() return { "--ignore-case" } end }) end,
  { desc = "Live grep (global search, case-insensitive)" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Find word under cursor" })
map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Find commands" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })

-------------------------------------------------------
-- LSP / Formatting
-------------------------------------------------------
map("n", "<leader>lf", function()
  vim.lsp.buf.format { async = true }
end, { desc = "Format current buffer" })

-------------------------------------------------------
-- Terminal Management (ToggleTerm)
-------------------------------------------------------
local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
  return
end

local Terminal = require("toggleterm.terminal").Terminal

-- Helper: create terminals with direction + index
local function get_term(direction, id)
  return Terminal:new({
    direction = direction,
    id = id,
    hidden = true,
    on_open = function(term)
      -- Keymaps inside terminal
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { buffer = term.bufnr, desc = "Exit terminal mode" })
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { buffer = term.bufnr, desc = "Go to left window" })
      vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { buffer = term.bufnr, desc = "Go to bottom window" })
      vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { buffer = term.bufnr, desc = "Go to top window" })
      vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { buffer = term.bufnr, desc = "Go to right window" })
    end,
  })
end

-- Bottom terminals
map("n", "<leader>tb", function() get_term("horizontal", 1):toggle() end, { desc = "Toggle bottom terminal" })
map("n", "<leader>tbn", function() get_term("horizontal"):toggle() end, { desc = "New bottom terminal" })
map("n", "<leader>tb1", function() get_term("horizontal", 1):toggle() end, { desc = "Bottom terminal 1" })
map("n", "<leader>tb2", function() get_term("horizontal", 2):toggle() end, { desc = "Bottom terminal 2" })
map("n", "<leader>tb3", function() get_term("horizontal", 3):toggle() end, { desc = "Bottom terminal 3" })

-- Right terminals
map("n", "<leader>tr", function() get_term("vertical", 1):toggle() end, { desc = "Toggle right terminal" })
map("n", "<leader>trn", function() get_term("vertical"):toggle() end, { desc = "New right terminal" })
map("n", "<leader>tr1", function() get_term("vertical", 1):toggle() end, { desc = "Right terminal 1" })
map("n", "<leader>tr2", function() get_term("vertical", 2):toggle() end, { desc = "Right terminal 2" })
map("n", "<leader>tr3", function() get_term("vertical", 3):toggle() end, { desc = "Right terminal 3" })

-- Floating terminals
map("n", "<leader>tf", function() get_term("float", 1):toggle() end, { desc = "Toggle floating terminal" })
map("n", "<leader>tfn", function() get_term("float"):toggle() end, { desc = "New floating terminal" })

-- Close all terminals
map("n", "<leader>tc", function()
  require("toggleterm").close_all()
end, { desc = "Close all terminals" })

-- Send command to terminal
map("n", "<leader>ts", function()
  local cmd = vim.fn.input("Send to terminal: ")
  if cmd ~= "" then
    local term = get_term("horizontal", 1)
    term:toggle()
    term:send(cmd)
  end
end, { desc = "Send command to terminal" })

-- Global terminal toggle (Ctrl+\)
map({ "n", "t" }, "<C-\\>", function()
  get_term("horizontal", 1):toggle()
end, { desc = "Toggle terminal" })
