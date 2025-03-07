-- Custom options

vim.opt.colorcolumn = "80"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Custom keybindings

-- Typing keymaps
vim.g.maplocalleader = ","
vim.keymap.set("n", "º", "<")
vim.keymap.set("n", "ª", ">")
vim.keymap.set("i", "º", "<")
vim.keymap.set("i", "ª", ">")
vim.keymap.set("c", "º", "<")
vim.keymap.set("c", "ª", ">")
vim.keymap.set("v", "º", "<")
vim.keymap.set("v", "ª", ">")
vim.keymap.set("n", "ºº", "<<")
vim.keymap.set("n", "ªª", ">>")
-- vim.keymap.set("n", "<M-t>", "<C-t>")

-- Terminal keymaps
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("n", "<C-S-k>", "<C-w>+")
vim.keymap.set("n", "<C-S-j>", "<C-w>-")
vim.keymap.set("n", "<C-S-h>", "<C-w><")
vim.keymap.set("n", "<C-S-l>", "<C-w>>")

-- NOTE: Old options, keep just in case
-- noremap º <
-- noremap ª >
-- inoremap º <
-- inoremap ª >
-- cnoremap º <
-- cnoremap ª >
