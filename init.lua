-- Load all the options
require 'options'

-- Load keymaps they have to come before loading which-key
require 'keymaps'

-- Add all plugins
require 'packages'

-- Load autocommands
require 'autocmds'

-- Load the previously saved colorscheme
require 'local_plugins.mng_colorschemes'
