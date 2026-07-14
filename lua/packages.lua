vim.pack.add {

  --[[ ================================================================= ]]
  -- General dependencies
  'https://github.com/nvim-tree/nvim-web-devicons',
  {
    src = 'https://github.com/nvim-lua/plenary.nvim', -- This is for code_companion and none-ls
    version = 'master',
  },

  -- nvim-cmp (editing)
  'https://github.com/L3MON4D3/LuaSnip', -- Snippet engine
  'https://github.com/hrsh7th/cmp-buffer', -- Buffer text source
  'https://github.com/hrsh7th/cmp-cmdline', -- command line
  'https://github.com/hrsh7th/cmp-nvim-lsp', -- LSP source
  'https://github.com/hrsh7th/cmp-omni', -- omni
  'https://github.com/hrsh7th/cmp-path', -- File system paths source
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/saadparwaiz1/cmp_luasnip', -- Snippet source

  -- treesitter
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
  },
  --[[ ================================================================= ]]

  -- colorschemes
  'https://codeberg.org/AndresYague/dracula.nvim',
  'https://github.com/EdenEast/nightfox.nvim',
  'https://github.com/catppuccin/nvim',
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/rebelot/kanagawa.nvim',
  'https://github.com/rose-pine/neovim',

  -- code_companion
  'https://github.com/olimorris/codecompanion.nvim',

  -- editing
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/ysmb-wtsg/in-and-out.nvim',

  -- vcs
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/tpope/vim-fugitive',

  -- lsp_setup
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvimtools/none-ls.nvim', -- Using this for fortls

  -- lualine
  'https://github.com/nvim-lualine/lualine.nvim',

  -- orgmode
  'https://github.com/chipsenkbeil/org-roam.nvim.git',
  'https://github.com/hugginsio/org-virtual-clocktime.nvim.git',
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
  'https://codeberg.org/AndresYague/fish-files.nvim',
  'https://codeberg.org/AndresYague/nvim-colorizer.lua',
  'https://codeberg.org/AndresYague/persistence.nvim',
  'https://codeberg.org/AndresYague/print-debug.nvim',
  'https://github.com/folke/flash.nvim',
  'https://github.com/kylechui/nvim-surround',
  {
    src = 'https://codeberg.org/AndresYague/no-neck-pain.nvim',
    version = 'my_main',
  },

  -- previewers
  'https://github.com/OXY2DEV/markview.nvim',

  -- quicklist
  'https://github.com/stevearc/quicker.nvim',

  -- remote-sshfs
  'https://github.com/AndresYague/remote-sshfs.nvim.git',

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

-- Make sure snacks-nvim and lsp_setup load ASAP
require 'plugins.snacks-nvim'
require 'plugins.lsp_setup' -- Cannot be named just "lsp" for mks to work well

require 'plugins.code_companion'
require 'plugins.colorschemes'
require 'plugins.editing'
require 'plugins.lualine'
require 'plugins.multicursor'
require 'plugins.oil'
require 'plugins.orgmode'
require 'plugins.others'
require 'plugins.picker'
require 'plugins.previewers'
require 'plugins.quicklist'
require 'plugins.remote-sshfs'
require 'plugins.treesitter'
require 'plugins.ui2'
require 'plugins.vcs'
require 'plugins.which-key'

-- Local plugins
require 'local_plugins.floating_term'
require 'local_plugins.local_diff'
require 'local_plugins.mng_colorschemes'
require 'local_plugins.mng_plugs'

-- Activate nvim plugins
vim.cmd.packadd { args = { 'nvim.undotree' }, bang = true }
vim.cmd.packadd { args = { 'termdebug' }, bang = true }
vim.cmd.packadd { args = { 'nvim.difftool' }, bang = true }
