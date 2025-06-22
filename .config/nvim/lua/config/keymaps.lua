-- Custom keybindings

-- Typing keymaps
vim.keymap.set({"n", "i", "c", "v"}, "º", "<")
vim.keymap.set({"n", "i", "c", "v"}, "ª", ">")
vim.keymap.set("n", "ºº", "<<")
vim.keymap.set("n", "ªª", ">>")

-- Terminal keymaps
vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>", {desc = "Enter normal mode from terminal"})
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", {desc = "Go to upper window"})
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", {desc = "Go to lower window"})
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", {desc = "Go to right window"})
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", {desc = "Go to left window"})

-- Window keymaps
vim.keymap.set("n", "<C-S-k>", "<C-w>+")
vim.keymap.set("n", "<C-S-j>", "<C-w>-")
vim.keymap.set("n", "<C-S-h>", "<C-w><")
vim.keymap.set("n", "<C-S-l>", "<C-w>>")

vim.keymap.set({"n", "i"}, "<C-C>", "<Cmd>fc<CR>", {desc = "Close floating window"})

-- Move line up and down, uncomment if needed
-- vim.keymap.set("n", "<M-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
-- vim.keymap.set("n", "<M-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
-- vim.keymap.set("i", "<M-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
-- vim.keymap.set("i", "<M-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })

require("config.move_closing_parens")
