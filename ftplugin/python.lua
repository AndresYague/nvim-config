-- Add python format to errorformat
-- FIXME: Does not work too well but it finds something
-- using vim.opt.errorformat:get() produces a table and this way does not work
-- at all.
vim.o.errorformat = vim.o.errorformat .. ',\\ \\ File "%f"\\, line %l\\, %m'

-- Make python add comments on new line
vim.bo.formatoptions = 'jcroql'

-- Change makeprg for python files
vim.bo.makeprg = 'python3 %'
