-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set up maplocalleader before lazyvim
vim.g.maplocalleader = ","

-- Lazy setup
require("config.lazy")

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- Set term to start with fish
vim.opt.shell = "fish"
