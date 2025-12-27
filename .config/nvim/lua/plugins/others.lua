require('persistence').setup {
  event = 'BufReadPre', -- this will only start session saving when an actual file was opened
}
require('move-enclosing').setup {
  { word_keymap = '<C-E>', WORD_keymap = '<C-S-E>' },
}
require('print-debug').setup {
  {
    mark = '"',
    keymap = '<leader>dp',
  },
}
require('nvim-surround').setup()
require('bufferline').setup {
  options = { numbers = 'none' },
}
require('flash').setup()

require('colorizer').setup({ '*' }, {
  RRGGBBAA = true, -- #RRGGBBAA hex codes
  css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
  mode = 'background',
})

-- Bufferline keymaps
vim.keymap.set(
  'n',
  '<leader>bp',
  vim.cmd.BufferLineCyclePrev,
  { desc = 'Go to left buffer' }
)
vim.keymap.set(
  'n',
  '<leader>bn',
  vim.cmd.BufferLineCycleNext,
  { desc = 'Go to right buffer' }
)
vim.keymap.set(
  'n',
  '<leader>bg',
  vim.cmd.BufferLinePick,
  { desc = 'Go to buffer' }
)
vim.keymap.set(
  'n',
  '<leader>bD',
  vim.cmd.BufferLinePickClose,
  { desc = 'Select delete buffer' }
)
vim.keymap.set('n', '<leader>bd', vim.cmd.bd, { desc = 'Buffer delete' })
vim.keymap.set(
  'n',
  '<leader>bo',
  vim.cmd.BufferLineCloseOthers,
  { desc = 'Buffer delete others' }
)

-- Persistence keymaps
-- Close current session
vim.keymap.set('n', '<leader>qq', vim.cmd.qa, { desc = 'Quit current session' })
-- load the session for the current directory
vim.keymap.set('n', '<leader>qs', function()
  require('persistence').load()
end, { desc = 'Load session in the current directory' })
-- select a session to load
vim.keymap.set('n', '<leader>qS', function()
  require('persistence').select()
end, { desc = 'Select session to load' })
-- load the last session
vim.keymap.set('n', '<leader>ql', function()
  require('persistence').load { last = true }
end, { desc = 'Load last session' })
-- stop Persistence => session won't be saved on exit
vim.keymap.set('n', '<leader>qd', function()
  require('persistence').stop()
end, { desc = 'Do not save session' })

-- Flash keymaps
vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
  require('flash').jump()
end, { desc = 'Flash' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
  require('flash').treesitter()
end, { desc = 'Flash Treesitter' })
vim.keymap.set('o', 'r', function()
  require('flash').remote()
end, { desc = 'Remote Flash' })
vim.keymap.set({ 'o', 'x' }, 'R', function()
  require('flash').treesitter_search()
end, { desc = 'Treesitter Search' })
vim.keymap.set({ 'c' }, '<c-s>', function()
  require('flash').toggle()
end, { desc = 'Toggle Flash Search' })
