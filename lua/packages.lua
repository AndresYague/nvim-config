vim.pack.add {

  --[[ ================================================================= ]]
  -- General dependencies
  'https://github.com/nvim-tree/nvim-web-devicons',

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
  'https://github.com/AndresYague/dracula.nvim',
  'https://github.com/EdenEast/nightfox.nvim',
  'https://github.com/catppuccin/nvim',
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/rebelot/kanagawa.nvim',
  'https://github.com/rose-pine/neovim',

  -- editing
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/ysmb-wtsg/in-and-out.nvim',

  -- vcs
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/tpope/vim-fugitive',

  -- lsp_config
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',

  -- lualine
  'https://github.com/nvim-lualine/lualine.nvim',

  -- orgmode
  'https://github.com/nvim-orgmode/org-bullets.nvim',
  'https://github.com/nvim-orgmode/orgmode',

  -- multicursor
  {
    src = 'https://github.com/jake-stewart/multicursor.nvim',
    version = '1.0',
  },

  -- oil
  'https://github.com/stevearc/oil.nvim',

  -- others
  'https://github.com/AndresYague/fish-files.nvim',
  'https://github.com/AndresYague/nvim-colorizer.lua',
  'https://github.com/AndresYague/print-debug.nvim',
  'https://github.com/folke/flash.nvim',
  'https://github.com/AndresYague/persistence.nvim',
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/shortcuts/no-neck-pain.nvim.git',

  -- previewers
  'https://github.com/OXY2DEV/markview.nvim',

  -- quicklist
  'https://github.com/stevearc/quicker.nvim',

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

-- Make sure snacks-nvim loads ASAP
require 'plugins.snacks-nvim'

require 'plugins.colorschemes'
require 'plugins.editing'
require 'plugins.lsp_config' -- Cannot be named just "lsp" for mks to work well
require 'plugins.lualine'
require 'plugins.multicursor'
require 'plugins.oil'
require 'plugins.orgmode'
require 'plugins.others'
require 'plugins.picker' -- Must come after plugins.lsp
require 'plugins.previewers'
require 'plugins.quicklist'
require 'plugins.treesitter'
require 'plugins.ui2'
require 'plugins.vcs'
require 'plugins.which-key'

-- Local plugins
require 'local_plugins.floating_term'
require 'local_plugins.mng_plugs'
require 'local_plugins.local_diff'

-- Activate nvim plugins
vim.cmd.packadd { args = { 'nvim.undotree' }, bang = true }
vim.cmd.packadd { args = { 'termdebug' }, bang = true }
vim.cmd.packadd { args = { 'nvim.difftool' }, bang = true }
