vim.keymap.set(
  { 'n' },
  '<leader>x',
  ':!chmod +x %<CR>',
  { desc = 'Make file executable' }
)
