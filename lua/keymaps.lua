-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', vim.cmd.nohlsearch)

-- Execute
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

-- Remap redo
vim.keymap.set('n', 'U', '<C-R>', { desc = 'Redo' })

-- Remap alternate-file
vim.keymap.set('n', '<leader>a', '<C-^>', { desc = 'Alternate file' })

-- Remap bracket operator
vim.keymap.set('o', 'ir', 'i[', { desc = 'inner []' })
vim.keymap.set('o', 'ar', 'a[', { desc = '[] block' })

-- Diagnostic keymaps
vim.keymap.set(
  'n',
  '<leader>dd',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic Quickfix list' }
)

-- Custom keybindings

-- Buffers keymaps
vim.keymap.set('n', '<leader>bd', vim.cmd.bd, { desc = 'Buffer delete' })
vim.keymap.set('n', '<leader>bo', function()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf == current_buf then
      goto continue
    end
    vim.api.nvim_buf_delete(buf, {})
    ::continue::
  end
end, { desc = 'Buffer delete others' })

-- Window navigation
vim.keymap.set(
  't',
  '<C-k>',
  '<C-\\><C-n><C-w>k',
  { desc = 'Go to upper window' }
)
vim.keymap.set(
  't',
  '<C-j>',
  '<C-\\><C-n><C-w>j',
  { desc = 'Go to lower window' }
)
vim.keymap.set(
  't',
  '<C-l>',
  '<C-\\><C-n><C-w>l',
  { desc = 'Go to right window' }
)
vim.keymap.set(
  't',
  '<C-h>',
  '<C-\\><C-n><C-w>h',
  { desc = 'Go to left window' }
)

-- Other window keymaps
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })
vim.keymap.set('n', '<C-S-k>', '<C-w>+', { desc = 'Resize window up' })
vim.keymap.set('n', '<C-S-j>', '<C-w>-', { desc = 'Resize window down' })
vim.keymap.set('n', '<C-S-h>', '<C-w><', { desc = 'Resize window left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>>', { desc = 'Resize window right' })
vim.keymap.set(
  { 'n', 'i' },
  '<C-C>',
  vim.cmd.fc,
  { desc = 'Close floating window' }
)

-- Window split keymaps
vim.keymap.set(
  'n',
  '<leader>|',
  vim.cmd.vsplit,
  { desc = 'Split window vertically' }
)
vim.keymap.set(
  'n',
  '<leader>-',
  vim.cmd.split,
  { desc = 'Split window horizontally' }
)

-- Terminal keymaps
vim.keymap.set(
  't',
  '<ESC><ESC>',
  '<C-\\><C-n>',
  { desc = 'Exit terminal mode' }
)

vim.keymap.set('n', '<leader>t|', function()
  vim.cmd.vsplit { args = { 'term://%:p:h//' .. vim.o.shell } }
end, { desc = 'Open terminal vertically (file location)' })
vim.keymap.set('n', '<leader>tv', function()
  vim.cmd.vsplit { args = { 'term://' .. vim.o.shell } }
end, { desc = 'Open terminal vertically (cwd)' })
vim.keymap.set('n', '<leader>t-', function()
  vim.cmd.split { args = { 'term://%:p:h//' .. vim.o.shell } }
end, { desc = 'Open terminal horizontally (file location)' })
vim.keymap.set('n', '<leader>th', function()
  vim.cmd.split { args = { 'term://' .. vim.o.shell } }
end, { desc = 'Open terminal horizontally (cwd)' })

-- Move line up and down
vim.keymap.set(
  'n',
  '<M-j>',
  "<cmd>execute 'move .+' . v:count1<cr>==",
  { desc = 'Move Down' }
)
vim.keymap.set(
  'n',
  '<M-k>',
  "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",
  { desc = 'Move Up' }
)
vim.keymap.set('i', '<M-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
vim.keymap.set('i', '<M-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })

-- Keymaps for diffmode
-- NOTE: There are keymaps that appear once fugitive is being used
-- see "autocmds.lua"
vim.keymap.set(
  'n',
  'gs',
  '<cmd>Gvdiffsplit!<CR>',
  { desc = 'Do a Gvdiffsplit!' }
)

-- Mason window display
vim.keymap.set('n', '<leader>cm', '<cmd>Mason<CR>', { desc = 'Mason window' })

-- Handy shortcut for calculator mode
vim.keymap.set('n', '<leader>cc', 'i<C-R>=', { desc = 'Calculator insert' })

-- Use the calculator in normal mode (requires having bc installed)
vim.keymap.set('x', '<leader>cc', ':!bc<CR>', { desc = 'Line calculator' })
