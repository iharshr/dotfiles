---@type ChadrcConfig
local M = {}

-- Base theme configuration
M.base46 = {
  theme = "onedark",

  -- Optional highlight overrides
  -- hl_override = {
  --     Comment = { italic = true },
  --     ["@comment"] = { italic = true },
  -- },
}

-- UI customizations - ENABLE GIT BRANCH IN STATUSLINE
M.ui = {
  statusline = {
    theme = "default", -- default, vscode, vscode_colored, minimal
    separator_style = "default", -- default, round, block, arrow
    
    -- Enable git branch/status display
    order = {
      "mode",
      "file",
      "git",  -- This adds git info
      "%=",   -- Right align everything after this
      "lsp_msg",
      "diagnostics",
      "lsp",
      "cwd",
      "cursor",
    },
    
    modules = {
      -- Customize git display (optional)
      git = function()
        if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
          return ""
        end

        local git_status = vim.b.gitsigns_status_dict
        local branch_name = git_status and git_status.head or ""
        
        if branch_name == "" then
          return ""
        end

        -- Show branch with icon and changes
        local added = git_status and git_status.added or 0
        local changed = git_status and git_status.changed or 0
        local removed = git_status and git_status.removed or 0
        
        local status = ""
        if added > 0 then
          status = status .. " +" .. added
        end
        if changed > 0 then
          status = status .. " ~" .. changed
        end
        if removed > 0 then
          status = status .. " -" .. removed
        end

        return "  " .. branch_name .. status .. " "
      end,
    },
  },

  tabufline = {
    enabled = true,
    lazyload = false,
    order = { "treeOffset", "buffers", "tabs" },
  },
}

-- Dashboard (nvdash) settings
-- M.nvdash = {
--     load_on_startup = true,
-- }

return M
