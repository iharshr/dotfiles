require "nvchad.autocmds"

-- CRITICAL: Global terminal keymaps for Ctrl+C interrupt signal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    local opts = { buffer = 0 }
    -- Allow Ctrl+C to send interrupt signal (SIGINT)
    vim.keymap.set("t", "<C-c>", "<C-c>", opts)
    -- Escape to exit terminal mode
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
  end,
})

-- Additional fix for ToggleTerm on re-open
vim.api.nvim_create_autocmd("TermEnter", {
  pattern = "term://*toggleterm#*",
  callback = function()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<C-c>", "<C-c>", opts)
  end,
})
