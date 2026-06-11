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

-- Load the previously saved colorscheme
require 'local_plugins.mng_colorschemes'
