-- These things only apply for nvim-0.13 and beyond
if vim.fn.has 'nvim-0.13.0' == 0 then
  return
end

local utils = require 'local_plugins.multicursor.utils'
local gutter = require 'local_plugins.multicursor.gutter'

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', function()
  -- Remove the multicursor only once hlsearch is off
  if vim.v.hlsearch == 0 then
    utils.clear_mc()
  end

  vim.cmd.nohlsearch()
end, { desc = 'Remove multicursors or search highlight' })

-- Make secondary cursors hl stand out better
vim.api.nvim_set_hl(0, 'MCursor', { reverse = true })

-- Put adding cursor in M-q to be consistent with the other keybinds
-- When removing a cursor, jump to the next one.
vim.keymap.set({ 'n', 'x' }, '<M-q>', function()
  local mc_space = vim.api.nvim_create_namespace 'nvim.multicursor'
  local mc_list = utils.mc_below_cursor()

  if #mc_list == 0 then
    -- No cursor to remove, just toggle
    vim.api.nvim_feedkeys('Q', 'nx', false)
  else
    -- Remove extmark and move cursor to closest remaining cursor
    vim.api.nvim_buf_del_extmark(0, mc_space, mc_list[1][1])
    utils.move_cursor_to_nearest_mc()
    gutter.clear_gutter()
  end

  gutter.add_gutter()
end, { desc = 'Add cursor' })

-- Clear multicursors without using C-L which we already have
-- for switching between windows...
vim.keymap.set('n', '<M-c>', function()
  utils.clear_mc()
end, { desc = 'Clear multicursors' })

-- Add multicursor here and jump to next or previous match of word
-- under cursor. Position initial cursor at the start of the word as well
-- with lb
vim.keymap.set('n', '<M-n>', function()
  if #utils.mc_below_cursor() == 0 then
    vim.api.nvim_feedkeys('lbQ*', 'nx', false)
  else
    vim.api.nvim_feedkeys('*', 'nx', false)
  end
  vim.cmd.nohlsearch()
  gutter.add_gutter()
end, { desc = 'Cursor and next match' })
vim.keymap.set('n', '<M-p>', function()
  if #utils.mc_below_cursor() == 0 then
    vim.api.nvim_feedkeys('lbQ#', 'nx', false)
  else
    vim.api.nvim_feedkeys('#', 'nx', false)
  end
  vim.cmd.nohlsearch()
  gutter.add_gutter()
end, { desc = 'Cursor and previous match' })
vim.keymap.set('n', '<M-N>', function()
  vim.api.nvim_feedkeys('*1Q[Cq=', 'nx', false)
  vim.cmd.nohlsearch()
  gutter.add_gutter()
end, { desc = 'Cursor on all matches ' })

-- Match in visual selection
vim.keymap.set('x', '<M-m>', function()
  -- Ask for match to user, put it in the last-pattern register
  vim.fn.setreg('/', vim.fn.escape(vim.fn.input { prompt = 'Match: ' }, '.\\'))

  -- Create the new cursors
  vim.api.nvim_feedkeys('1Q', 'nx', false)

  -- Move cursor without leaving trace
  utils.move_cursor_to_nearest_mc()

  -- Put them in follow mode
  vim.api.nvim_feedkeys('q=', 'nx', false)
  gutter.add_gutter()
end, { desc = 'Cursor on match' })

-- Add multicursor here and move up or down
-- Make sure we skip blank space
vim.keymap.set('n', '<M-j>', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local nlines = 1
  while true do
    local lines =
      vim.api.nvim_buf_get_lines(0, pos[1] + nlines - 2, pos[1] + nlines, false)

    -- End of file
    if lines == nil then
      break
    end

    -- Check if the line can hold that cursor
    if #lines[2] >= pos[2] then
      vim.api.nvim_feedkeys('2q=Q' .. nlines .. 'j', 'nx', false)
      gutter.add_gutter()
      return
    end

    -- Increase nlines
    nlines = nlines + 1
  end
end, { desc = 'Cursor and down' })
vim.keymap.set('n', '<M-k>', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local nlines = 1
  while true do
    local lines =
      vim.api.nvim_buf_get_lines(0, pos[1] - nlines - 1, pos[1] - nlines, false)

    -- End of file
    if lines == nil then
      break
    end

    -- Check if the line can hold that cursor
    if #lines[1] >= pos[2] then
      vim.api.nvim_feedkeys('2q=Q' .. nlines .. 'k', 'nx', false)
      gutter.add_gutter()
      return
    end

    -- Increase nlines
    nlines = nlines + 1
  end
end, { desc = 'Cursor and up' })

-- Cycle main cursor with h and l, make sure to turn off follow-mode
vim.keymap.set('n', '<M-l>', '2q=]C', { desc = 'Next cursor' })
vim.keymap.set('n', '<M-h>', '2q=[C', { desc = 'Previous cursor' })

-- Follow toggle
vim.keymap.set('n', '<M-f>', 'q=', { desc = 'Cursor toggle follow' })
