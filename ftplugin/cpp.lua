vim.bo.tabstop = 2
vim.bo.shiftwidth = 2

-- For some reason cpp does not start the treesitter stuff from the autocmd for
-- the filetype, so start stuff here.
vim.treesitter.start(0, "cpp")
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
