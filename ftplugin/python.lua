-- Add python format to errorformat
-- FIXME: Does not work too well: fix the errorformat
vim.opt.errorformat:append { '\\ \\ File "%f"\\', 'line %l\\', '%m' }

-- Make python add comments on new line
vim.bo.formatoptions = 'jcroql'

-- Change makeprg for python files
vim.bo.makeprg = 'python3 %'
