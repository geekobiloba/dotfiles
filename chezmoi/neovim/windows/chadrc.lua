-- Neovim may modify this file, like when selecting a different theme.
-- And on Windows, it will save this with CR-LF line endings.
-- This is why we have two different chadrc.lua files:
-- one for Windows and another for Unix-like OSes.

-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "oxocarbon",

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.nvdash = { load_on_startup = true }
M.ui = {
  tabufline = {
    lazyload = false
  },
  statusline = {
    theme = 'vscode_colored',
  },
}

return M
