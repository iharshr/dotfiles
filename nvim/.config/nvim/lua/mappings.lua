-- Keymaps configuration
local map = vim.keymap.set

-------------------------------------------------------
-- General
-------------------------------------------------------
-- Copy selected text (visual mode)
map("v", "<C-c>", '"+y', { noremap = true, silent = true })

-- Paste in normal/insert modes
map("n", "<C-v>", '"+p', { noremap = true, silent = true })
map("i", "<C-v>", '<Esc>"+pa', { noremap = true, silent = true })

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
map(
  "n",
  "<leader>ff",
  "<cmd>lua require('telescope.builtin').find_files({ hidden = true, no_ignore = true, file_ignore_patterns = {'.git/', 'node_modules/', 'build/', 'dist/'} })<cr>",
  { desc = "Find files including hidden but exclude common ignored folders" }
)
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
-- Terminal Management (ToggleTerm)
-------------------------------------------------------
local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
  return
end

local Terminal = require("toggleterm.terminal").Terminal

local function get_term(direction, id)
  return Terminal:new({
    direction = direction,
    id = id,
    hidden = true,
    on_open = function(term)
      -- Keymaps inside terminal
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { buffer = term.bufnr, desc = "Exit terminal mode" })
      
      -- Window navigation from terminal
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { buffer = term.bufnr, desc = "Go to left window" })
      vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { buffer = term.bufnr, desc = "Go to bottom window" })
      vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { buffer = term.bufnr, desc = "Go to top window" })
      vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { buffer = term.bufnr, desc = "Go to right window" })
      
      -- IMPORTANT: Allow Ctrl+C to send interrupt signal in terminal mode
      -- This removes the copy binding in terminal mode
      vim.keymap.set("t", "<C-c>", "<C-c>", { buffer = term.bufnr, desc = "Send interrupt signal" })
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

-------------------------------------------------------
-- LSP Navigation & Information
-------------------------------------------------------
-- Go to definition
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })

-- Go to declaration
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })

-- Go to implementation
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })

-- Go to type definition
map("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
map("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })

-- Find references
map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
map("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find references" })

-- Hover documentation
map("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })
map("n", "<leader>k", vim.lsp.buf.hover, { desc = "Show hover documentation" })

-- Signature help (shows function parameters)
map("n", "<leader>sh", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })

-------------------------------------------------------
-- LSP Code Actions & Refactoring
-------------------------------------------------------
-- Code actions (quick fixes, refactoring)
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
map({ "n", "v" }, "<leader>.", vim.lsp.buf.code_action, { desc = "Code actions" })

-- Rename symbol
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Format current buffer
map("n", "<leader>lf", function()
  vim.lsp.buf.format { async = true }
end, { desc = "Format buffer" })
map({ "n", "v" }, "<leader>fm", function()
  vim.lsp.buf.format { async = true }
end, { desc = "Format buffer/selection" })

-------------------------------------------------------
-- Diagnostics (Errors, Warnings, etc.)
-------------------------------------------------------
-- Show diagnostics in floating window
map("n", "<leader>do", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
map("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- Go to next/previous diagnostic
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

-- Go to next/previous error (severity = ERROR only)
map("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })
map("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous error" })

-- Show all diagnostics in location list
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })

-- Show all diagnostics in quickfix
map("n", "<leader>dq", vim.diagnostic.setqflist, { desc = "Diagnostics to quickfix" })

-------------------------------------------------------
-- Telescope LSP Integration (Fuzzy Finding)
-------------------------------------------------------
map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })
map("n", "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace symbols" })
map("n", "<leader>ld", "<cmd>Telescope diagnostics<cr>", { desc = "Show diagnostics" })
map("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", { desc = "Find references (Telescope)" })
map("n", "<leader>lD", "<cmd>Telescope lsp_definitions<cr>", { desc = "Find definitions (Telescope)" })
map("n", "<leader>li", "<cmd>Telescope lsp_implementations<cr>", { desc = "Find implementations (Telescope)" })

-------------------------------------------------------
-- Workspace Management
-------------------------------------------------------
map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
map("n", "<leader>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "List workspace folders" })

-------------------------------------------------------
-- Peek Definition (without leaving current buffer)
-------------------------------------------------------
-- Using Telescope for peek
map("n", "<leader>pd", function()
  require("telescope.builtin").lsp_definitions({
    jump_type = "never",
  })
end, { desc = "Peek definition" })

-------------------------------------------------------
-- Inlay Hints (Show inline type hints)
-------------------------------------------------------
map("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-------------------------------------------------------
-- Advanced: Split Navigation
-------------------------------------------------------
-- Open definition in vertical split
map("n", "<leader>vd", function()
  vim.cmd("vsplit")
  vim.lsp.buf.definition()
end, { desc = "Open definition in vsplit" })

-- Open definition in horizontal split
map("n", "<leader>sd", function()
  vim.cmd("split")
  vim.lsp.buf.definition()
end, { desc = "Open definition in split" })

-------------------------------------------------------
-- Document Outline (symbols)
-------------------------------------------------------
-- Requires aerial.nvim or symbols-outline.nvim (optional plugins)
map("n", "<leader>lo", "<cmd>AerialToggle<cr>", { desc = "Toggle outline" })

-------------------------------------------------------
-- Quick Diagnostic Navigation
-------------------------------------------------------
-- Jump to first error in file
map("n", "<leader>de", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, wrap = false })
end, { desc = "Jump to first error" })


-------------------------------------------------------
-- Multi-Cursor / Visual Multi
-------------------------------------------------------
-- NOTE: Add these to your mappings.lua file

-- Visual line selection with Shift+Up/Down (extends selection)
map("n", "<S-Up>", "V<Up>", { desc = "Select line up" })
map("n", "<S-Down>", "V<Down>", { desc = "Select line down" })
map("v", "<S-Up>", "<Up>", { desc = "Extend selection up" })
map("v", "<S-Down>", "<Down>", { desc = "Extend selection down" })

-- For vim-visual-multi: Ctrl+D to select next occurrence (like VSCode)
-- This is configured in the plugin init function, but you can also map it here
map({ "n", "v" }, "<C-d>", function()
  -- Check if vim-visual-multi is loaded
  if vim.fn.exists(":VMStart") == 2 then
    -- In normal mode, start multi-cursor on word under cursor
    -- In visual mode, find next occurrence of selection
    vim.cmd("silent! call vm#commands#find_under(0, 1)")
  else
    -- Fallback to native behavior or multicursors.nvim
    local ok, multicursors = pcall(require, "multicursors")
    if ok then
      vim.cmd("MCunderCursor")
    else
      -- Native Vim behavior: scroll down half page
      vim.cmd("normal! <C-d>")
    end
  end
end, { desc = "Multi-cursor: Select next occurrence" })

-- Ctrl+Shift+D to select all occurrences
map({ "n", "v" }, "<C-S-d>", function()
  if vim.fn.exists(":VMStart") == 2 then
    vim.cmd("silent! call vm#commands#find_all(0, 1)")
  end
end, { desc = "Multi-cursor: Select all occurrences" })

-- Skip current and select next (like VSCode Ctrl+K, Ctrl+D)
map("n", "<C-k><C-d>", function()
  if vim.fn.exists(":VMStart") == 2 then
    vim.cmd("silent! call vm#commands#skip_and_find_next()")
  end
end, { desc = "Multi-cursor: Skip and find next" })

-- Escape to exit multi-cursor mode
map("n", "<Esc>", function()
  if vim.fn.exists("*vm#is_active") == 1 and vim.fn["vm#is_active"]() == 1 then
    vim.cmd("VMClear")
  else
    vim.cmd("nohlsearch")
  end
end, { desc = "Clear multi-cursor or search highlight" })

-- Alternative: Add cursors above/below current line (Column mode)
-- These are already configured in vim-visual-multi with Shift+Up/Down
-- But if you want explicit keybinds:
map("n", "<C-S-Up>", function()
  if vim.fn.exists(":VMStart") == 2 then
    vim.cmd("silent! call vm#commands#add_cursor_up(1)")
  end
end, { desc = "Add cursor above" })

map("n", "<C-S-Down>", function()
  if vim.fn.exists(":VMStart") == 2 then
    vim.cmd("silent! call vm#commands#add_cursor_down(1)")
  end
end, { desc = "Add cursor below" })

-------------------------------------------------------
-- Visual Mode Enhancements
-------------------------------------------------------
-- Move selected lines up/down with Alt+Up/Down
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Indent/outdent in visual mode and stay in visual mode
map("v", "<", "<gv", { desc = "Outdent and reselect" })
map("v", ">", ">gv", { desc = "Indent and reselect" })

-- Duplicate line/selection
map("n", "<C-S-k>", "yyP", { desc = "Duplicate line up" })
map("n", "<C-S-j>", "yyp", { desc = "Duplicate line down" })
map("v", "<C-S-k>", "y`>p", { desc = "Duplicate selection down" })
