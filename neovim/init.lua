vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

--------------------------------------------------------------------------------
-- Blinking cursor
--------------------------------------------------------------------------------

vim.o.guicursor = table.concat({
  "n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100",
  "i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100",
  "r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100",
}, ",")

--------------------------------------------------------------------------------
-- UFO config
--------------------------------------------------------------------------------

vim.o.foldcolumn     = "1" -- '0' is not bad
vim.o.foldlevel      = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable     = true
vim.o.fillchars      = [[eob: ,fold: ,foldopen:⌵,foldsep: ,foldclose:⌃]]

--------------------------------------------------------------------------------
-- Use PowerShell for Windows shell
--------------------------------------------------------------------------------

if vim.loop.os_uname().sysname == 'Windows_NT' then
  vim.o.shell = 'pwsh.exe'
end

--------------------------------------------------------------------------------
-- Crystal nvim-treesitter installer
-- See: https://github.com/crystal-lang-tools/tree-sitter-crystal
--------------------------------------------------------------------------------

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.crystal = {
  install_info = {
    url = "$HOME/.tree-sitter-crystal",
    files = {"src/parser.c", "src/scanner.c"},
    branch = "main",
  },
  filetype = "cr",
}

--------------------------------------------------------------------------------
-- Move buffer left, right, first, or last
--------------------------------------------------------------------------------

local function move_buf_left()
  local bufs = vim.t.bufs
  local cbuf = vim.api.nvim_get_current_buf() -- current buffer number

  for idx, bufnum in ipairs(bufs) do
    if bufnum == cbuf and idx > 1 then
      bufs[idx], bufs[idx - 1] = bufs[idx - 1], bufs[idx]

      break
    end
  end

  -- Update buffer list and redraw tabline
  vim.t.bufs = bufs
  vim.cmd("redrawtabline")
end

local function move_buf_first()
  local bufs = vim.t.bufs
  local cbuf = vim.api.nvim_get_current_buf() -- current buffer number

  for idx, bufnum in ipairs(bufs) do
    if bufnum == cbuf and idx > 1 then
      for i = idx, 2, -1 do
        bufs[i], bufs[i - 1] = bufs[i - 1], bufs[i]
      end

      break
    end
  end

  -- Update buffer list and redraw tabline
  vim.t.bufs = bufs
  vim.cmd("redrawtabline")
end

local function move_buf_right()
  local bufs = vim.t.bufs
  local cbuf = vim.api.nvim_get_current_buf() -- current buffer number
  local nbuf = #bufs

  for idx, bufnum in ipairs(bufs) do
    if bufnum == cbuf and idx < nbuf then
      bufs[idx], bufs[idx + 1] = bufs[idx + 1], bufs[idx]

      break
    end
  end

  -- Update buffer list and redraw tabline
  vim.t.bufs = bufs
  vim.cmd("redrawtabline")
end

local function move_buf_last()
  local cbuf = vim.api.nvim_get_current_buf() -- current buffer number
  local bufs = vim.t.bufs
  local nbuf = #bufs

  for idx, bufnum in ipairs(bufs) do
    if bufnum == cbuf and idx < nbuf then
      for i = idx, nbuf - 1 do
        bufs[i], bufs[i + 1] = bufs[i + 1], bufs[i]
      end

      break
    end
  end

  -- Update buffer list and redraw tabline
  vim.t.bufs = bufs
  vim.cmd("redrawtabline")
end

vim.keymap.set("n", "<leader>Bh", move_buf_left , { desc = "Move buffer left"      })
vim.keymap.set("n", "<leader>Bl", move_buf_right, { desc = "Move buffer right"     })
vim.keymap.set("n", "<leader>B0", move_buf_first, { desc = "Move buffer leftmost"  })
vim.keymap.set("n", "<leader>B$", move_buf_last , { desc = "Move buffer rightmost" })

FoldColumn = {
  bg = "NONE",
  fg = "red",
  --fg = "grey",
}

--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------

-- See lua/configs/lspconfig.lua

--------------------------------------------------------------------------------
-- mini
--------------------------------------------------------------------------------

-- map
local MiniMap = require('mini.map')
-- require('mini.map').setup({
MiniMap.setup({
  window = {
    focusable = true,
  },
  symbols = {
    encode = MiniMap.gen_encode_symbols.dot('3x2'),
    --block = '2x2',
  },
})

vim.keymap.set('n', '<Leader>mc', MiniMap.close,        { desc = "Close MiniMap"                })
vim.keymap.set('n', '<Leader>mf', MiniMap.toggle_focus, { desc = "Toggle MiniMap focus"         })
vim.keymap.set('n', '<Leader>mo', MiniMap.open,         { desc = "Open MiniMap"                 })
vim.keymap.set('n', '<Leader>mr', MiniMap.refresh,      { desc = "Refresh MiniMap"              })
vim.keymap.set('n', '<Leader>ms', MiniMap.toggle_side,  { desc = "Toggle MiniMap side position" })
vim.keymap.set('n', '<Leader>mt', MiniMap.toggle,       { desc = "Toggle MiniMap"               })

-- Open mini.map by default
-- MiniMap.open()

--------------------------------------------------------------------------------
-- Load .nvim.lua in current directory
--------------------------------------------------------------------------------

vim.o.exrc = true

--------------------------------------------------------------------------------
-- symbols-outline
--------------------------------------------------------------------------------

require("outline").setup({
  providers = {
    priority = { 'lsp', 'coc', 'markdown', 'norg', 'treesitter' },
  },

  -- Using the default doesn't work somehow
  symbols = {
    filter = {
      'Array',
      'Boolean',
      'Class',
      'Component',
      'Constant',
      'Constructor',
      'Enum',
      'EnumMember',
      'Event',
      'Field',
      'File',
      'Fragment',
      'Function',
      'Interface',
      'Key',
      'Macro',
      'Method',
      'Module',
      'Namespace',
      'Null',
      'Number',
      'Object',
      'Operator',
      'Package',
      'Parameter',
      'Property',
      'StaticMethod',
      'String',
      'Struct',
      'TypeAlias',
      'TypeParameter',
      'Variable',
    },
  },
  -- preview_window = {
  --   auto_preview = true,
  -- },
  outline_items = {
    show_symbol_lineno = true,
  },
  -- Enable mouse click, see: https://github.com/hedyhli/outline.nvim/issues/56
  keymaps = {
    goto_location = {"<CR>", "<LeftRelease>"},
  },
})

