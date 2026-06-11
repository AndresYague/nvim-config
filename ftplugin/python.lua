-- Add python format to errorformat
vim.o.errorformat = vim.o.errorformat .. ',\\ \\ File "%f"\\, line %l\\, %m'

-- Make python add comments on new line
vim.bo.formatoptions = 'jcroql'

-- Change makeprg for python files
vim.bo.makeprg = 'python3 %'
