local git_str = 'https://github.com/'
vim.pack.add {

  --[[ ================================================================= ]]
  -- General dependencies
  git_str .. 'nvim-lua/plenary.nvim',
  git_str .. 'nvim-tree/nvim-web-devicons',
  git_str .. 'rcarriga/nvim-notify',
  git_str .. 'vhyrro/luarocks.nvim',

  -- blink
  {
    src = git_str .. 'saghen/blink.cmp',
    version = vim.version.range '1.*',
  },

  -- treesitter
  {
    src = git_str .. 'nvim-treesitter/nvim-treesitter',
    version = vim.version.range '0.10.0',
  },
  --[[ ================================================================= ]]

  -- colorschemes
  git_str .. 'EdenEast/nightfox.nvim',
  git_str .. 'folke/tokyonight.nvim',
  git_str .. 'neanias/everforest-nvim',
  git_str .. 'projekt0n/github-nvim-theme',
  git_str .. 'rebelot/kanagawa.nvim',

  -- editing

  -- NOTE: luasnip requires going to
  -- $HOME/.local/share/nvim/site/pack/core/opt/LuaSnip
  -- or equivalent and running make install_jsregexp
  git_str .. 'L3MON4D3/LuaSnip',

  git_str .. 'folke/todo-comments.nvim',
  git_str .. 'numToStr/Comment.nvim',
  git_str .. 'rafamadriz/friendly-snippets',
  git_str .. 'stevearc/conform.nvim',
  git_str .. 'windwp/nvim-autopairs',

  -- git
  git_str .. 'AndresYague/git-worktree.nvim',
  git_str .. 'lewis6991/gitsigns.nvim',
  git_str .. 'tpope/vim-fugitive',

  -- harpoon
  {
    src = git_str .. 'ThePrimeagen/harpoon',
    version = 'harpoon2',
  },

  -- lsp
  git_str .. 'WhoIsSethDaniel/mason-tool-installer.nvim',
  git_str .. 'folke/lazydev.nvim',
  git_str .. 'j-hui/fidget.nvim',
  git_str .. 'mason-org/mason-lspconfig.nvim',
  git_str .. 'mason-org/mason.nvim',
  git_str .. 'neovim/nvim-lspconfig',

  -- lualine
  git_str .. 'nvim-lualine/lualine.nvim',

  -- navigation
  git_str .. 'ysmb-wtsg/in-and-out.nvim',

  -- neorg
  git_str .. '3rd/image.nvim',
  git_str .. 'nvim-neorg/lua-utils.nvim',
  git_str .. 'nvim-neorg/neorg',
  git_str .. 'nvim-neotest/nvim-nio',
  git_str .. 'nvim-neotest/nvim-nio',
  git_str .. 'pysan3/pathlib.nvim',

  -- noice
  git_str .. 'MunifTanjim/nui.nvim',
  git_str .. 'folke/noice.nvim',

  -- oil
  git_str .. 'stevearc/oil.nvim.git',

  -- others
  git_str .. 'AndresYague/move-enclosing.nvim',
  git_str .. 'AndresYague/nvim-colorizer.lua',
  git_str .. 'AndresYague/print-debug.nvim',
  git_str .. 'akinsho/bufferline.nvim',
  git_str .. 'folke/flash.nvim',
  git_str .. 'folke/persistence.nvim',
  git_str .. 'kylechui/nvim-surround',

  -- previewers
  git_str .. 'OXY2DEV/markview.nvim',

  -- quicklist
  git_str .. 'stevearc/quicker.nvim',

  -- recorder
  git_str .. 'AndresYague/nvim-recorder',

  -- snacks
  git_str .. 'folke/snacks.nvim',

  -- treesitter
  git_str .. 'nvim-treesitter/nvim-treesitter-context',
  git_str .. 'nvim-treesitter/nvim-treesitter-textobjects',

  -- vimdocs
  git_str .. 'ibhagwan/ts-vimdoc.nvim',

  -- which-key
  git_str .. 'folke/which-key.nvim',
}

-- Make sure luarocks is started before other plugins
require('luarocks-nvim').setup()

-- Make sure snacks-nvim loads quick
require 'plugins.snacks-nvim'

require 'plugins.colorschemes'
require 'plugins.editing'
require 'plugins.git'
require 'plugins.harpoon'
require 'plugins.lsp'
require 'plugins.lualine'
require 'plugins.navigation'
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
