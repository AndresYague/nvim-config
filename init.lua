-- Load all the options
require 'options'

-- Make the vim shell "fish"
vim.opt.shell = 'fish'
vim.opt.foldlevelstart = 99

-- Load keymaps they have to come before loading which-key
require 'keymaps'

-- Add all plugins
require 'packages'

-- Load autocommands
require 'autocmds'

-- Load health
require 'health'

-- Load language specific options and autocmds
require 'languages.cpp'
require 'languages.lua'
require 'languages.python'

-- Try to load these colorschemes in order
require('local_plugins.mng_colorschemes')
local priority = require('local_plugins.mng_colorschemes').priority

local load_colorschemes = {
  priority,
  'catppuccin',
  'kanagawa',
  'nightfox',
  'tokyonight'
}

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
  vim.cmd.colorscheme 'slate'
end

-- The modeline
-- vim: ts=2 sts=2 sw=2 et
