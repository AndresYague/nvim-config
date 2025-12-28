-- Custom functions

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Folding expressions

local ignore_filetypes_folding =
{ 'gitcommit', 'gitrebase', 'svg', 'hgcommit', 'fugitive' }

vim.api.nvim_create_autocmd({ 'FileType' }, {
  callback = function()
    if vim.tbl_contains(ignore_filetypes_folding, vim.bo.filetype) then
      return
    end

    if pcall(vim.treesitter.get_parser) then
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    else
      vim.opt.foldmethod = 'syntax'
    end
  end,
})
