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
}
