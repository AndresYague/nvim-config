-- Change these options for cpp and lua
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'lua',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})
