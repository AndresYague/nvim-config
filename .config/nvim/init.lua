-- Load all the options
require 'options'

-- Make the vim shell "fish"
vim.opt.shell = 'fish'
vim.opt.foldlevelstart = 99

-- Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]

-- Load keymaps they have to come before loading which-key
require 'keymaps'

require('lazy').setup({

  -- Import all plugins inside of the "plugins" directory
  { import = 'plugins' },

  -- Add treesitter
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Load autocommands
require 'autocmds'

-- Add python format to errorformat
vim.o.errorformat = vim.o.errorformat .. ',\\ \\ File "%f"\\, line %l\\, %m'

-- Load health
require 'health'

-- Disable treesitter-context
require('treesitter-context').disable()

-- Add incremental selection keymaps
require('nvim-treesitter.configs').setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      scope_incremental = '<CR>',
      node_incremental = '<TAB>',
      node_decremental = '<S-TAB>',
    },
  },
}

-- Try to load these colorschemes in order
local load_colorschemes = { 'nightfox', 'tokyonight' }

-- Set colorscheme
local found = nil
local colorschemes = vim.fn.getcompletion('', 'color')
for i, load_col in ipairs(load_colorschemes) do
  for _, col in ipairs(colorschemes) do
    if load_col == col then
      found = i
      break
    end
  end

  if found then
    break
  end
end

if found then
  vim.cmd.colorscheme(load_colorschemes[found])
else
  vim.cmd.colorscheme 'default'
end

-- The modeline
-- vim: ts=2 sts=2 sw=2 et
