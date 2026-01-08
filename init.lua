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
if priority == '' then
  vim.cmd.colorscheme 'slate'
else
  vim.cmd.colorscheme(priority)
end

-- The modeline
-- vim: ts=2 sts=2 sw=2 et
