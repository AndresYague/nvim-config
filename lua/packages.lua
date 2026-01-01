vim.pack.add {

  --[[ ================================================================= ]]
  -- General dependencies
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/rcarriga/nvim-notify',
  'https://github.com/vhyrro/luarocks.nvim',

  -- blink
  -- NOTE: The version is specified so the rust fuzzy find can be compiled
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = vim.version.range '1.*',
  },

  -- treesitter
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
  },
  --[[ ================================================================= ]]

  -- colorschemes
  'https://github.com/EdenEast/nightfox.nvim',
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/rebelot/kanagawa.nvim',

  -- editing

  -- NOTE: luasnip requires going to
  -- $HOME/.local/share/nvim/site/pack/core/opt/LuaSnip
  -- or equivalent and running "make install_jsregexp"
  'https://github.com/L3MON4D3/LuaSnip',

  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/ysmb-wtsg/in-and-out.nvim',

  -- git
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/tpope/vim-fugitive',

  -- lsp
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',

  -- lualine
  'https://github.com/nvim-lualine/lualine.nvim',

  -- neorg
  'https://github.com/3rd/image.nvim',
  'https://github.com/nvim-neorg/lua-utils.nvim',
  'https://github.com/nvim-neorg/neorg',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/pysan3/pathlib.nvim',

  -- noice
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/folke/noice.nvim',

  -- oil
  'https://github.com/stevearc/oil.nvim',

  -- others
  'https://github.com/AndresYague/move-enclosing.nvim',
  'https://github.com/AndresYague/nvim-colorizer.lua',
  'https://github.com/AndresYague/print-debug.nvim',
  'https://github.com/folke/flash.nvim',
  'https://github.com/folke/persistence.nvim',
  'https://github.com/kylechui/nvim-surround',

  -- previewers
  'https://github.com/OXY2DEV/markview.nvim',

  -- quicklist
  'https://github.com/stevearc/quicker.nvim',

  -- recorder
  'https://github.com/AndresYague/nvim-recorder',

  -- snacks
  'https://github.com/folke/snacks.nvim',

  -- treesitter
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    version = 'main',
  },

  -- vimdocs
  'https://github.com/ibhagwan/ts-vimdoc.nvim',

  -- which-key
  'https://github.com/folke/which-key.nvim',
}

-- Make sure luarocks is started before other plugins
require('luarocks-nvim').setup()

-- Make sure snacks-nvim loads ASAP
-- but after luarocks-nvim
require 'plugins.snacks-nvim'

require 'plugins.colorschemes'
require 'plugins.editing'
require 'plugins.git'
require 'plugins.lsp'
require 'plugins.lualine'
require 'plugins.neorg'
require 'plugins.noice'
require 'plugins.oil'
require 'plugins.others'
require 'plugins.picker'
require 'plugins.previewers'
require 'plugins.quicklist'
require 'plugins.recorder'
require 'plugins.treesitter'
require 'plugins.which-key'

-- Local plugins
require 'local_plugins.floating_term'
require 'local_plugins.mng_plugs'
