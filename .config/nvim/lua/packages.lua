---@param package_str string
---@param specs table?
---@param opts table?
local github_pack_add = function(package_str, specs, opts)
  local specs_tbl = { src = 'https://github.com/' .. package_str }
  if specs then
    specs_tbl = vim.tbl_extend('error', specs_tbl, specs)
  end
  vim.pack.add({ specs_tbl }, opts)
end

--[[ ================================================================= ]]
-- General dependencies
github_pack_add 'nvim-lua/plenary.nvim'
github_pack_add 'nvim-tree/nvim-web-devicons'
github_pack_add 'rcarriga/nvim-notify'
github_pack_add 'vhyrro/luarocks.nvim'

-- blink
github_pack_add 'saghen/blink.cmp'

-- treesitter
github_pack_add(
  'nvim-treesitter/nvim-treesitter',
  { version = vim.version.range '0.10.0' }
)
--[[ ================================================================= ]]

-- colorschemes
github_pack_add 'EdenEast/nightfox.nvim'
github_pack_add 'folke/tokyonight.nvim'
github_pack_add 'neanias/everforest-nvim'
github_pack_add 'projekt0n/github-nvim-theme'
github_pack_add 'rebelot/kanagawa.nvim'

-- editing
github_pack_add 'folke/todo-comments.nvim'
github_pack_add 'numToStr/Comment.nvim'
github_pack_add 'stevearc/conform.nvim'
github_pack_add 'windwp/nvim-autopairs'

-- git
github_pack_add 'AndresYague/git-worktree.nvim'
github_pack_add 'lewis6991/gitsigns.nvim'
github_pack_add 'tpope/vim-fugitive'

-- harpoon
github_pack_add('ThePrimeagen/harpoon', { version = 'harpoon2' })

-- lsp
github_pack_add 'folke/lazydev.nvim'
-- github_pack_add 'neovim/nvim-lspconfig'

-- lualine
github_pack_add 'nvim-lualine/lualine.nvim'

-- navigation
github_pack_add 'ysmb-wtsg/in-and-out.nvim'

-- neorg
github_pack_add '3rd/image.nvim'
github_pack_add 'nvim-neorg/lua-utils.nvim'
github_pack_add 'nvim-neorg/neorg'
github_pack_add 'nvim-neotest/nvim-nio'
github_pack_add 'nvim-neotest/nvim-nio'
github_pack_add 'pysan3/pathlib.nvim'

-- noice
github_pack_add 'MunifTanjim/nui.nvim'
github_pack_add 'folke/noice.nvim'

-- oil
github_pack_add 'stevearc/oil.nvim.git'

-- others
github_pack_add 'AndresYague/move-enclosing.nvim'
github_pack_add 'AndresYague/nvim-colorizer.lua'
github_pack_add 'AndresYague/print-debug.nvim'
github_pack_add 'akinsho/bufferline.nvim'
github_pack_add 'folke/flash.nvim'
github_pack_add 'folke/persistence.nvim'
github_pack_add 'kylechui/nvim-surround'

-- previewers
github_pack_add 'OXY2DEV/markview.nvim'

-- quicklist
github_pack_add 'stevearc/quicker.nvim'

-- recorder
github_pack_add 'AndresYague/nvim-recorder'

-- snacks
github_pack_add 'folke/snacks.nvim'

-- treesitter
github_pack_add 'nvim-treesitter/nvim-treesitter-context'
github_pack_add 'nvim-treesitter/nvim-treesitter-textobjects'

-- which-key
github_pack_add 'folke/which-key.nvim'

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
