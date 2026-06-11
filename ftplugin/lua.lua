vim.bo.tabstop = 2
vim.bo.shiftwidth = 2

-- Lua specific keymaps

-- Execute commands
vim.keymap.set(
  { 'n', 'v' },
  '<leader>xx',
  ':.lua<CR>',
  { desc = 'Execute lua line' }
)
vim.keymap.set(
  { 'n' },
  '<leader>xf',
  ':%lua<CR>',
  { desc = 'Execute lua file' }
)
vim.keymap.set(
  { 'n' },
  '<leader>xp',
  'yy:lua vim.print(<C-R>")<CR>',
  { desc = 'Print lua line' }
)
