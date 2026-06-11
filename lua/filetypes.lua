-- Cpp
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'cpp',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})

-- Lua
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'lua',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2

    -- Lua specific keymaps

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
    vim.keymap.set(
      { 'n' },
      '<leader>xp',
      'yy:lua vim.print(<C-R>")<CR>',
      { desc = 'Print lua line' }
    )
  end,
})

-- Python
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'python' },
  callback = function()
    -- Add python format to errorformat
    vim.o.errorformat = vim.o.errorformat .. ',\\ \\ File "%f"\\, line %l\\, %m'

    -- Make python add comments on new line
    vim.bo.formatoptions = 'jcroql'

    -- Change makeprg for python files
    vim.bo.makeprg = 'python3 %'
  end,
})

-- Bash
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'sh' },
  callback = function()
    vim.keymap.set(
      { 'n' },
      '<leader>x',
      ':!chmod +x %<CR>',
      { desc = 'Make file executable' }
    )
  end,
})
