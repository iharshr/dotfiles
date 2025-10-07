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
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function()
      require("configs.lspconfig")
    end
  },

  -- Mason package manager
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
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
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",  -- CHANGED from typescript-language-server
        "eslint", -- CHANGED from eslint-lsp
        "jsonls",
        "yamlls",
        "dockerls",
        "graphql",  -- CHANGED from graphql-language-service-cli
        "prismals", -- CHANGED from prisma-language-server
        "gopls",
        "pyright",
        "ruff", -- CHANGED from ruff-lsp
        "html",
        "cssls",
        "emmet_ls",    -- CHANGED from emmet-ls
        "tailwindcss", -- CHANGED from tailwindcss-language-server
        "marksman",    -- CHANGED from markdownlint
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
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
      }
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",   desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",    desc = "Recent files" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find word under cursor" }
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
      -- Load fzf extension with error handling
      pcall(telescope.load_extension, "fzf")
    end
  },

  -- File operations (Oil.nvim)
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Oil",
    keys = {
      { "<leader>o", "<cmd>Oil<cr>", desc = "Open Oil file manager" }
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
    event = { "BufReadPre", "BufNewFile" },
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
  -- markdown viewer for nvim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" },
    },
    opts = {
      file_types = { "markdown" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
    },
  },
  -- Symbol Outline (VSCode-like outline sidebar)
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen" },
    keys = {
      { "<leader>lo", "<cmd>AerialToggle<cr>", desc = "Toggle outline" },
      { "<leader>lO", "<cmd>AerialOpen<cr>",   desc = "Open outline" },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = {
        max_width = { 40, 0.2 },
        width = nil,
        min_width = 20,
        default_direction = "prefer_right",
      },
      attach_mode = "global",
      close_automatic_events = {},
      keymaps = {
        ["?"] = "actions.show_help",
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.jump",
        ["<2-LeftMouse>"] = "actions.jump",
        ["<C-v>"] = "actions.jump_vsplit",
        ["<C-s>"] = "actions.jump_split",
        ["p"] = "actions.scroll",
        ["<C-j>"] = "actions.down_and_scroll",
        ["<C-k>"] = "actions.up_and_scroll",
        ["{"] = "actions.prev",
        ["}"] = "actions.next",
        ["[["] = "actions.prev_up",
        ["]]"] = "actions.next_up",
        ["q"] = "actions.close",
        ["o"] = "actions.tree_toggle",
        ["za"] = "actions.tree_toggle",
        ["O"] = "actions.tree_toggle_recursive",
        ["zA"] = "actions.tree_toggle_recursive",
        ["l"] = "actions.tree_open",
        ["zo"] = "actions.tree_open",
        ["L"] = "actions.tree_open_recursive",
        ["zO"] = "actions.tree_open_recursive",
        ["h"] = "actions.tree_close",
        ["zc"] = "actions.tree_close",
        ["H"] = "actions.tree_close_recursive",
        ["zC"] = "actions.tree_close_recursive",
        ["zr"] = "actions.tree_increase_fold_level",
        ["zR"] = "actions.tree_open_all",
        ["zm"] = "actions.tree_decrease_fold_level",
        ["zM"] = "actions.tree_close_all",
        ["zx"] = "actions.tree_sync_folds",
        ["zX"] = "actions.tree_sync_folds",
      },
      show_guides = true,
      filter_kind = false,
      highlight_on_hover = true,
      autojump = false,
      on_attach = function(bufnr)
        -- Jump forward/backward with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
    },
  },

  -- Better LSP UI (prettier dialogs and popups)
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>cf", "<cmd>Lspsaga finder<cr>",               desc = "LSP Finder (refs/impl/def)" },
      { "<leader>ca", "<cmd>Lspsaga code_action<cr>",          desc = "Code action",               mode = { "n", "v" } },
      { "<leader>rn", "<cmd>Lspsaga rename<cr>",               desc = "Rename" },
      { "gd",         "<cmd>Lspsaga peek_definition<cr>",      desc = "Peek definition" },
      { "gD",         "<cmd>Lspsaga goto_definition<cr>",      desc = "Go to definition" },
      { "gt",         "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek type definition" },
      { "K",          "<cmd>Lspsaga hover_doc<cr>",            desc = "Hover documentation" },
      { "<leader>o",  "<cmd>Lspsaga outline<cr>",              desc = "Toggle outline" },
      { "[e",         "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Previous diagnostic" },
      { "]e",         "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next diagnostic" },
      {
        "[E",
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "Previous error"
      },
      {
        "]E",
        function()
          require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "Next error"
      },
    },
    opts = {
      ui = {
        border = "rounded",
        code_action = "",
      },
      lightbulb = {
        enable = false,
        sign = false,
      },
      symbol_in_winbar = {
        enable = true,
      },
      outline = {
        win_width = 30,
        auto_preview = false,
      },
    },
  },

  -- Trouble.nvim - Beautiful diagnostics list
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP references" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix list" },
    },
    opts = {},
  },

  -- Glance.nvim - Prettier peek definition
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    keys = {
      { "gd", "<cmd>Glance definitions<cr>",      desc = "Peek definitions" },
      { "gr", "<cmd>Glance references<cr>",       desc = "Peek references" },
      { "gt", "<cmd>Glance type_definitions<cr>", desc = "Peek type definitions" },
      { "gi", "<cmd>Glance implementations<cr>",  desc = "Peek implementations" },
    },
    opts = {
      height = 18,
      border = {
        enable = true,
      },
    },
  },

  -- nvim-navbuddy - Breadcrumbs and quick navigation
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>ln", "<cmd>Navbuddy<cr>", desc = "Nav breadcrumbs" },
    },
    opts = {
      lsp = {
        auto_attach = true,
      },
    },
  },

  -- Barbecue - VSCode-like breadcrumbs in winbar
  {
    "utilyre/barbecue.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      theme = "auto",
      show_dirname = true,
      show_basename = true,
    },
  },
  -- NeoVim / Vim Types
  {
    "folke/neodev.nvim",
    event = "VeryLazy",
    config = function()
      require("neodev").setup({
        library = {
          enabled = true, -- globally enable
          runtime = true, -- include Neovim runtime files
          types = true,   -- include type info
          plugins = true, -- include installed plugins
        },
      })
    end,
  },

   -- Gitsigns - Git decorations (added/modified/deleted lines)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signcolumn = true,
      current_line_blame = true, -- Shows inline blame
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Next git hunk" })

        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Previous git hunk" })

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
        map("n", "<leader>tlb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
        map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
        map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Diff this ~" })
        map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
      end,
    },
  },

  -- Neogit - Magit clone for Neovim (like VSCode Source Control)
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Neogit push<cr>", desc = "Git push" },
      { "<leader>gP", "<cmd>Neogit pull<cr>", desc = "Git pull" },
    },
    opts = {
      integrations = {
        telescope = true,
        diffview = true,
      },
      graph_style = "unicode",
    },
  },

  -- Diffview - Advanced diff viewer
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_horizontal",
        },
      },
    },
  },

  -- Git Blame - Show git blame in virtual text
  {
    "f-person/git-blame.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
      { "<leader>go", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Open commit in browser" },
    },
    opts = {
      enabled = false, -- Don't enable by default (toggle with <leader>gb)
      message_template = " <author> • <date> • <summary>",
      date_format = "%r",
      virtual_text_column = 80,
    },
  },

  -- Fugitive - Classic Git wrapper (powerful commands)
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gl", "<cmd>Git log<cr>", desc = "Git log" },
      { "<leader>gL", "<cmd>Git log --oneline --graph --all<cr>", desc = "Git log (graph)" },
      { "<leader>gB", "<cmd>Git blame<cr>", desc = "Git blame (fugitive)" },
      { "<leader>gw", "<cmd>Gwrite<cr>", desc = "Git add (write)" },
      { "<leader>gr", "<cmd>Gread<cr>", desc = "Git checkout (read)" },
    },
  },

  -- Telescope Git extensions
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>fgb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      { "<leader>fgc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>fgs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
      { "<leader>fgh", "<cmd>Telescope git_stash<cr>", desc = "Git stash" },
      { "<leader>fgf", "<cmd>Telescope git_files<cr>", desc = "Git files" },
    },
  },

  -- GitLinker - Copy git links to clipboard
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>gy", mode = { "n", "v" }, desc = "Copy git link" },
      { "<leader>gY", mode = { "n", "v" }, desc = "Open git link in browser" },
    },
    config = function()
      require("gitlinker").setup({
        mappings = "<leader>gy",
      })
      vim.keymap.set({ "n", "v" }, "<leader>gY", function()
        require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").open_in_browser })
      end, { desc = "Open git link in browser" })
    end,
  },

  -- Git-Conflict - Resolve merge conflicts
  {
    "akinsho/git-conflict.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>co", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose ours" },
      { "<leader>ct", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose theirs" },
      { "<leader>cb", "<cmd>GitConflictChooseBoth<cr>", desc = "Choose both" },
      { "<leader>c0", "<cmd>GitConflictChooseNone<cr>", desc = "Choose none" },
      { "]x", "<cmd>GitConflictNextConflict<cr>", desc = "Next conflict" },
      { "[x", "<cmd>GitConflictPrevConflict<cr>", desc = "Previous conflict" },
      { "<leader>cl", "<cmd>GitConflictListQf<cr>", desc = "List conflicts" },
    },
    opts = {
      default_mappings = false,
      disable_diagnostics = true,
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
  },

  -- Multiple cursors plugin (VSCode-like multi-cursor)
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      -- Use Ctrl+N for next match (default behavior)
      -- Use Ctrl+Down/Up for creating cursors above/below
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",           -- Start multi-cursor on word
        ["Find Subword Under"] = "<C-d>",   -- Start multi-cursor on word
        ["Add Cursor Down"] = "<S-Down>",   -- Add cursor below
        ["Add Cursor Up"] = "<S-Up>",       -- Add cursor above
        ["Select All"] = "<C-S-l>",         -- Select all occurrences
        ["Start Regex Search"] = "<C-/>",   -- Start regex search
        ["Add Cursor At Pos"] = "<C-S-LeftMouse>", -- Click to add cursor
        ["Mouse Cursor"] = "<C-LeftMouse>", -- Mouse cursor
        ["Mouse Word"] = "<C-RightMouse>",  -- Mouse word
        ["Mouse Column"] = "<M-C-RightMouse>", -- Mouse column
      }
      
      -- Theme settings
      vim.g.VM_theme = "ocean"
      
      -- Highlight settings
      vim.g.VM_highlight_matches = "underline"
      
      -- Don't show messages
      vim.g.VM_silent_exit = 1
      
      -- Set leader for VM commands (optional)
      vim.g.VM_leader = "\\"
    end,
  },
}
