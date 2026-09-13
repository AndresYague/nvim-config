-- Add python format to errorformat
vim.opt.errorformat = vim.opt.errorformat:get()
  .. ',\\ \\ File "%f"\\, line %l\\, %m'

-- Make python add comments on new line
vim.bo.formatoptions = 'jcroql'

-- Change makeprg for python files
vim.bo.makeprg = 'python3 %'
