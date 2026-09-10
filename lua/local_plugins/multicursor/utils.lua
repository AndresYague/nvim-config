local M = {}

local gutter = require 'local_plugins.multicursor.gutter'

M.mc_below_cursor = function()
  local cpos = vim.api.nvim_win_get_cursor(0)
  local mc_list = vim.api.nvim_buf_get_extmarks(
    0,
    vim.api.nvim_create_namespace 'nvim.multicursor',
    { cpos[1] - 1, cpos[2] },
    { cpos[1] - 1, cpos[2] + 1 },
    {}
  )

  return mc_list
end

M.clear_mc = function()
  vim.api.nvim_buf_clear_namespace(
    0,
    vim.api.nvim_create_namespace 'nvim.multicursor',
    0,
    -1
  )
  gutter.clear_gutter()
end

return M
