return {
    -- Formatter/Code actions
    {
        "stevearc/conform.nvim",
        lazy = true,
        event = "BufWritePre",
        opts = require("configs.conform")
    },
    
    -- LSPConfig core
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim"},
        config = function()
            require("configs.lspconfig")
        end
    },
    
    -- Mason package manager
    {
        "williamboman/mason.nvim",
        cmd = {"Mason", "MasonInstall", "MasonUpdate"},
        opts = {
            ui = {
                border = "rounded"
            }
        }
    },
    
    -- Mason LSPConfig bridge - FIXED server names
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
        event = {"BufReadPre", "BufNewFile"},
        opts = {
            ensure_installed = {
                "lua_ls",
                "ts_ls",              -- CHANGED from typescript-language-server
                "eslint",             -- CHANGED from eslint-lsp
                "jsonls",
                "yamlls",
                "dockerls",
                "graphql",            -- CHANGED from graphql-language-service-cli
                "prismals",           -- CHANGED from prisma-language-server
                "gopls",
                "pyright",
                "ruff",               -- CHANGED from ruff-lsp
                "html",
                "cssls",
                "emmet_ls",           -- CHANGED from emmet-ls
                "tailwindcss",        -- CHANGED from tailwindcss-language-server
                "marksman",           -- CHANGED from markdownlint
                "biome"
            },
            automatic_installation = true
        }
    },
    
    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },
    
    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        lazy = false,
        config = function()
            require("toggleterm").setup {
                size = 15,
                open_mapping = [[<c-\>]],
                shade_terminals = true,
                shading_factor = 2,
                direction = "horizontal",
                float_opts = {
                    border = "curved"
                }
            }
        end
    },
    
    -- Telescope (Fuzzy Finder)
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make"
            }
        },
        cmd = "Telescope",
        keys = {
            {"<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files"},
            {"<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep"},
            {"<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers"},
            {"<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags"},
            {"<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files"},
            {"<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find word under cursor"}
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = "move_selection_next",
                            ["<C-k>"] = "move_selection_previous"
                        }
                    }
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true
                    }
                }
            })
            telescope.load_extension("fzf")
        end
    },
    
    -- File operations (Oil.nvim)
    {
        "stevearc/oil.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        cmd = "Oil",
        keys = {
            {"<leader>o", "<cmd>Oil<cr>", desc = "Open Oil file manager"}
        },
        opts = {
            delete_to_trash = true,
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = true
            },
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-v>"] = "actions.select_vsplit",
                ["<C-x>"] = "actions.select_split",
                ["<C-t>"] = "actions.select_tab",
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = "actions.tcd",
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden"
            }
        }
    },
    
    -- Inline Error Display (like VSCode Error Lens)
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = {"BufReadPre", "BufNewFile"},
        config = function()
            require("lsp_lines").setup()
            
            -- Disable virtual_text since we're using lsp_lines
            vim.diagnostic.config({
                virtual_text = false,
                virtual_lines = true,
            })
            
            -- Toggle keybinding
            vim.keymap.set("n", "<leader>tl", function()
                local new_value = not vim.diagnostic.config().virtual_lines
                vim.diagnostic.config({
                    virtual_lines = new_value,
                })
            end, { desc = "Toggle LSP lines" })
        end
    },
    
    -- Alternative: Tiny-inline-diagnostic (lighter alternative)
    -- Uncomment this and comment out lsp_lines if you prefer
    -- {
    --     "rachartier/tiny-inline-diagnostic.nvim",
    --     event = {"BufReadPre", "BufNewFile"},
    --     config = function()
    --         require('tiny-inline-diagnostic').setup({
    --             preset = "modern", -- Options: "modern", "classic", "minimal"
    --             options = {
    --                 show_source = true,
    --                 multilines = true,
    --             }
    --         })
    --         vim.diagnostic.config({ virtual_text = false })
    --     end
    -- }
}
