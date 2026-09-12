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

---@alias match
---| '*' # Go to next
---| '#' # Go to previous

-- Helper to jump to the next or previous match
---@param jump_mode match
---@return nil
M.jump_to_match = function(jump_mode)
  -- Save column before jump
  local column = vim.api.nvim_win_get_cursor(0)[2]

  if #M.mc_below_cursor() == 0 then
    vim.api.nvim_feedkeys('2q=Q' .. jump_mode .. '1q=', 'nx', false)
  else
    vim.api.nvim_feedkeys('2q=' .. jump_mode .. '1q=', 'nx', false)
  end

  -- Set cursor back to the same column but different row
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_win_set_cursor(0, {row, column})
  vim.cmd.nohlsearch()
end

return M
