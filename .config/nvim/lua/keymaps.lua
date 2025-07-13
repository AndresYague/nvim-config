-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', vim.cmd.nohlsearch)

-- Diagnostic keymaps
vim.keymap.set(
  'n',
  '<leader>f',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic Quickfix list' }
)

-- Custom keybindings

-- Color-picker
vim.keymap.set(
  'n',
  '<leader>uC',
  '<cmd>Telescope colorscheme<CR>',
  { desc = 'Colorscheme' }
)

-- Lazy
vim.keymap.set('n', '<leader>l', vim.cmd.Lazy, { desc = 'Lazy' })

-- Persistence

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

-- Terminal keymaps
vim.keymap.set(
  't',
  '<ESC><ESC>',
  '<C-\\><C-n>',
  { desc = 'Exit terminal mode' }
)
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

-- Window keymaps
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Window keymaps
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

-- Bufferline keymaps
vim.keymap.set(
  'n',
  '<S-h>',
  vim.cmd.BufferLineCyclePrev,
  { desc = 'Go to left buffer' }
)
vim.keymap.set(
  'n',
  '<S-l>',
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
vim.keymap.set(
  'n',
  '<leader>bp',
  vim.cmd.BufferLineTogglePin,
  { desc = 'Pin buffer' }
)
vim.keymap.set('n', '<leader>bP', function()
  vim.cmd.BufferLineGroupClose { args = { 'ungrouped' } }
end, { desc = 'Delete unpinned buffers' })
vim.keymap.set('n', '<leader>bd', vim.cmd.bd, { desc = 'Buffer delete' })
vim.keymap.set(
  'n',
  '<leader>bo',
  vim.cmd.BufferLineCloseOthers,
  { desc = 'Buffer delete others' }
)

-- Window keymaps
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

-- Loadview
vim.keymap.set('n', 'zl', vim.cmd.loadview, { desc = 'Loadview' })

-- These are the "TODO" search keymaps
vim.keymap.set(
  'n',
  '<leader>st',
  vim.cmd.TodoTelescope,
  { desc = 'Search for TODO comments' }
)
vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next todo comment' })
vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous todo comment' })

-- Git worktree keymaps
vim.keymap.set('n', '<leader>gwc', ':lua require("telescope").extensions.git_worktree.create_git_worktree()<CR>', { desc = 'Create worktree' })

vim.keymap.set('n', '<leader>gwd', ':lua require("telescope").extensions.git_worktree.delete_git_worktree()<CR>', { desc = 'Delete worktree' })

vim.keymap.set('n', '<leader>gws', ':lua require("telescope").extensions.git_worktree.git_worktrees()<CR>', { desc = 'Switch worktree' })

-- Handy shortcut for calculator mode
vim.keymap.set('n', '<leader>cc', 'i<C-R>=', { desc = 'Calculator insert' })

-- Remove undesired mappings from LSP
local remove_lsp_mapping = function(mode, lhs)
  local map_desc = vim.fn.maparg(lhs, mode, false, true).desc
  if map_desc == nil or string.find(map_desc, 'vim%.lsp') == nil then
    return
  end
  vim.keymap.del(mode, lhs)
end

remove_lsp_mapping('n', 'gra')
remove_lsp_mapping('x', 'gra')
remove_lsp_mapping('n', 'gri')
remove_lsp_mapping('n', 'grr')
remove_lsp_mapping('n', 'grn')
remove_lsp_mapping('n', 'gd')
remove_lsp_mapping('n', 'gD')
