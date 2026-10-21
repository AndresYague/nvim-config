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

---Toggle follow mode to `false` if it was active before and to `true`
---after calling `f(args)`, returning its value
---@param f function
---@param args any[]?
---@return any
M.follow_context = function(f, args)
  -- Toggle follow mode off
  local follow_mode = vim.opt.follow:get()
  if follow_mode then
    vim.opt.follow = false
  end

  -- Call function
  local ret
  if args then
    ret = f(unpack(args))
  else
    ret = f()
  end

  if follow_mode then
    vim.opt.follow = true
  end

  return ret
end

--- Move the main cursor to the closest multicursor in L1 distance
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

  -- Put cursor there (follow mode sensitive)
  if closest.pos then
    M.follow_context(
      vim.api.nvim_win_set_cursor,
      { 0, { closest.pos[2] + 1, closest.pos[3] } }
    )
  end
end

--- Align multicursors to the furthest right one (but lowest column value if
--- in the same row)
M.align_cursors = function()
  local function align(tag, y, x, max_xcoord, mc_namespace)
    local diff = max_xcoord - x
    local line = vim.api.nvim_buf_get_lines(0, y, y + 1, true)[1]
    vim.api.nvim_buf_set_lines(0, y, y + 1, true, {
      string.sub(line, 1, x)
        .. string.rep(' ', diff)
        .. string.sub(line, x + 1),
    })

    -- Set all the cursors where they were (plus diff)
    vim.print(tag)
    if tag ~= 0 then
      vim.api.nvim_buf_set_extmark(0, mc_namespace, y, x + diff, {})
    else
      vim.api.nvim_win_set_cursor(0, { y + 1, x + diff })
    end
  end

  -- Cannot be a cascading case
  if (!vim.v.cascading) then
    local mc_namespace = vim.api.nvim_create_namespace 'nvim.multicursor'
    local mc_list = vim.api.nvim_buf_get_extmarks(0, mc_namespace, 0, -1, {})

    -- Add the current cursor to the list
    local cpos = vim.api.nvim_win_get_cursor(0)
    mc_list[#mc_list + 1] = { 0, cpos[1] - 1, cpos[2] }

    -- Look for the first cursor in every line and record the largest x-position
    local max_xcoord = 0
    local prev_y = 0
    local coord_list = {}
    for _, pos in ipairs(mc_list) do
      if pos[2] ~= prev_y then
        coord_list[#coord_list + 1] = pos
        max_xcoord = math.max(max_xcoord, pos[3])
      end

      prev_y = pos[2]
    end

    -- Clear mc so we can set them up again after we are done
    M.clear_mc()

    -- Now go again for every cursor and add the difference between its x and
    -- the max_xcoord, do not do it while cascading
    for _, pos in ipairs(coord_list) do
      align(pos[1], pos[2], pos[3], max_xcoord, mc_namespace)
    end
  end
end

return M
