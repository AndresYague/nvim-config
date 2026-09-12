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

M.move_cursor_to_nearest_mc = function()
  local cpos = vim.api.nvim_win_get_cursor(0)
  local mc_list = vim.api.nvim_buf_get_extmarks(
    0,
    vim.api.nvim_create_namespace 'nvim.multicursor',
    0,
    -1,
    {}
  )

  -- Find closest position, the `+1` added everywhere is due
  -- to "nvim_win_get_cursor" and "nvim_buf_get_extmarks" being
  -- 1-indexed and 0-indexed respectively for the row number
  local closest = { pos = nil, dist = nil }
  for _, pos in ipairs(mc_list) do
    -- Simple L1 distance
    local dist = vim.fn.abs(pos[2] - cpos[1] + 1) + vim.fn.abs(pos[3] - cpos[2])

    -- Save closest seen so far
    if closest.dist == nil or closest.dist > dist then
      closest.dist = dist
      closest.pos = pos
    end
  end

  -- Put cursor there
  if closest.pos then
    vim.api.nvim_win_set_cursor(0, { closest.pos[2] + 1, closest.pos[3] })
  end
end

return M
