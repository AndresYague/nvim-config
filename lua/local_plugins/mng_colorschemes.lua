-- Attempt to save and load the latest colorscheme

-- Find where we save the colorscheme file
local cs_path =
  vim.fs.joinpath(vim.fs.abspath(vim.fn.stdpath 'config'), 'colorscheme.txt')

-- When requiring this file, read the color
local _, priority = pcall(io.lines(cs_path))

-- When leaving neovim, write the current color
vim.api.nvim_create_autocmd('VimLeave', {
  group = vim.api.nvim_create_augroup('load colorscheme', {clear = false}),
  callback = function()
    local fwrite = io.open(cs_path, 'w+')
    if fwrite then
      fwrite:write(vim.g.colors_name)
      fwrite:close()
    end
  end,
  once = true,
})

if priority == '' then
  vim.cmd.colorscheme 'slate'
else
  vim.cmd.colorscheme(priority)
end
