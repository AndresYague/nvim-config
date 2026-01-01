-- Add python format to errorformat
vim.o.errorformat = vim.o.errorformat .. ',\\ \\ File "%f"\\, line %l\\, %m'

-- Make python add comments on new line
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'python' },
  callback = function()
    vim.bo.formatoptions = 'jcroql'
  end,
})

-- Change makeprg for python files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'python' },
  callback = function()
    vim.bo.makeprg = 'python3 %'
  end,
})

