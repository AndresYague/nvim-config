-- CPP
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'cpp',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})

-- LUA
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'lua',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})

-- PYTHON
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
