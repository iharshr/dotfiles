-- Force filetype detection for common files
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.lua",
    callback = function()
        vim.bo.filetype = "lua"
    end
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"*.js", "*.jsx"},
    callback = function()
        if vim.fn.expand("%:e") == "jsx" then
            vim.bo.filetype = "javascriptreact"
        else
            vim.bo.filetype = "javascript"
        end
    end
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"*.ts", "*.tsx"},
    callback = function()
        if vim.fn.expand("%:e") == "tsx" then
            vim.bo.filetype = "typescriptreact"
        else
            vim.bo.filetype = "typescript"
        end
    end
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.py",
    callback = function()
        vim.bo.filetype = "python"
    end
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.go",
    callback = function()
        vim.bo.filetype = "go"
    end
})

-- Enable filetype detection globally (this was missing!)
vim.cmd([[
  filetype on
  filetype plugin on
  filetype indent on
]])
