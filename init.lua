-- Load all the options
require 'options'

-- Make the vim shell "fish"
vim.opt.shell = 'fish'
vim.opt.foldlevelstart = 99
vim.opt.concealcursor = 'nc'

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

-- Load the previously saved colorscheme
require 'local_plugins.mng_colorschemes'

-- The modeline
-- vim: ts=2 sts=2 sw=2 et
