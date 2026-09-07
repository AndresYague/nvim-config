-- Enable the loader, it may help. This has to be on top.
vim.loader.enable()

-- Load all the options
require 'options'

-- Load keymaps they have to come before loading which-key
require 'keymaps'

-- Load autocommands
require 'autocmds'

-- Add all plugins
require 'packages'
