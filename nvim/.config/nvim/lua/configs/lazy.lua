return {
  -- Default behavior for plugins
  defaults = { lazy = true },

  -- Colorscheme(s) to install on first setup
  install = { colorscheme = { "nvchad" } },

  -- UI settings for Lazy.nvim
  ui = {
    icons = {
      ft = "",         -- filetype icon
      lazy = "󰂠 ",     -- lazy-loaded plugin
      loaded = "",     -- loaded plugin
      not_loaded = "", -- not loaded plugin
    },
  },

  -- Performance optimizations
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
}
