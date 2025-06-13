return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- { "neovim/nvim-lspconfig", },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },

  ------------------------------------------------------------------------------
  -- marks.nvim
  ------------------------------------------------------------------------------

  {
    "chentoast/marks.nvim",
    event  = "BufRead",
    config = function()
      require'marks'.setup {
        -- whether to map keybinds or not. default true
        default_mappings = true,
        -- which builtin marks to show. default {}
        builtin_marks = { ".", "<", ">", "^" },
        -- whether movements cycle back to the beginning/end of buffer. default true
        cyclic = true,
        -- whether the shada file is updated after modifying uppercase marks. default false
        force_write_shada = false,
        -- how often (in ms) to redraw signs/recompute mark positions.
        -- higher values will have better performance but may cause visual lag,
        -- while lower values may cause performance penalties. default 150.
        refresh_interval = 250,
        -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
        -- marks, and bookmarks.
        -- can be either a table with all/none of the keys, or a single number, in which case
        -- the priority applies to all marks.
        -- default 10.
        sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
        -- disables mark tracking for specific filetypes. default {}
        excluded_filetypes = {},
        -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
        -- sign/virttext. Bookmarks can be used to group together positions and quickly move
        -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
        -- default virt_text is "".
        bookmark_0 = {
          sign = "⚑",
          virt_text = "hello world",
          -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
          -- defaults to false.
          annotate = false,
        },
        mappings = {}
      }
    end
  },

  ------------------------------------------------------------------------------
  -- twilight.nvim
  ------------------------------------------------------------------------------

  {
    "folke/twilight.nvim",
    event = "BufRead",
    opts  = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
    }
  },

  -- nvim-ufo
  {
    "kevinhwang91/nvim-ufo",
    event        = "BufRead",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            relculright = true,
            segments = {
              { text = { builtin.foldfunc      }, click = "v:lua.ScFa" },
              { text = { "%s"                  }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          })
        end,
      },
    },

    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },

    init = function()
      vim.keymap.set("n", "zR",
        function()
          require("ufo").openAllFolds()
        end
      )
      vim.keymap.set("n", "zM",
        function()
          require("ufo").closeAllFolds()
        end
      )
    end,
  },

  ------------------------------------------------------------------------------
  -- Fold preview
  ------------------------------------------------------------------------------

  {
    "anuvyklack/fold-preview.nvim",
    dependencies = "anuvyklack/keymap-amend.nvim",
    event  = "BufRead",
    config = true,
  },

  ------------------------------------------------------------------------------
  -- mini.map
  ------------------------------------------------------------------------------

  { 'echasnovski/mini.map', version = '*' },

  ------------------------------------------------------------------------------
  -- symbols-outline
  ------------------------------------------------------------------------------
  -- { 'simrat39/symbols-outline.nvim' },

  ------------------------------------------------------------------------------
  -- outline
  ------------------------------------------------------------------------------
  {
    'hedyhli/outline.nvim',
    config = function()
      require('outline').setup({
        providers = {
          priority = { 'lsp', 'coc', 'markdown', 'norg', 'treesitter' },
        },
      })
      vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>",
        { desc = "Toggle Outline" })
    end,
    event = "VeryLazy",
    dependencies = {
      'epheien/outline-treesitter-provider.nvim'
    },
  },

  ------------------------------------------------------------------------------
  -- Treesitter autoinstall
  ------------------------------------------------------------------------------

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = true,
    }
  }
}
