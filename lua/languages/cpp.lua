-- Change these options for cpp
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'cpp',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})
