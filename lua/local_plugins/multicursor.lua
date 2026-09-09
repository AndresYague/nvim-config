-- These things only apply for nvim-0.13 and beyond
if vim.fn.has 'nvim-0.13.0' == 0 then
  return
end

local function mc_below_cursor()
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

-- Add gutter visual info on where there are new cursors

-- This is the sign
vim.fn.sign_define('mc_gutter', { text = '|', texthl = 'CursorLineSign' })

-- Create the namespace for all below
_ = vim.api.nvim_create_namespace 'mc_gutter'

-- Keep track of all the signs so we can remove them easily
local all_signs = {}

local function add_gutter()
  local bufname = vim.fn.bufname '%'
  local mc_space = vim.api.nvim_create_namespace 'nvim.multicursor'

  local function add_sign_line(lnum)
    -- Create sign and assign ID, then add the sign to the list
    table.insert(all_signs, {
      buffer = bufname,
      group = 'mc_gutter',
      id = vim.fn.sign_place(
        0,
        'mc_gutter',
        'mc_gutter',
        bufname,
        { lnum = lnum }
      ),
    })
  end

  -- Look for extmarks from the cursor position
  for _, pos in ipairs(vim.api.nvim_buf_get_extmarks(0, mc_space, 0, -1, {})) do
    add_sign_line(pos[2] + 1)
  end

  -- Finally, add the cursor to the list, but only if we have multicursors
  if #all_signs > 0 then
    add_sign_line(vim.api.nvim_win_get_cursor(0)[1])
  end
end

local function clear_gutter()
  -- Remove all signs first
  vim.fn.sign_unplacelist(all_signs)
  all_signs = {}
end

vim.api.nvim_create_autocmd('CursorHold', {
  group = vim.api.nvim_create_augroup('MC_gutter', { clear = true }),
  callback = function()
    clear_gutter()
    add_gutter()
  end,
})

local function clear_mc()
  vim.api.nvim_buf_clear_namespace(
    0,
    vim.api.nvim_create_namespace 'nvim.multicursor',
    0,
    -1
  )
  clear_gutter()
end

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', function()
  -- Remove the multicursor only once hlsearch is off
  if vim.v.hlsearch == 0 then
    clear_mc()
  end

  vim.cmd.nohlsearch()
end, { desc = 'Remove multicursors or search highlight' })

-- Make secondary cursors hl stand out better
vim.api.nvim_set_hl(0, 'MCursor', { reverse = true })

-- Put adding cursor in M-q to be consistent with the other keybinds
-- When removing a cursor, jump to the next one.
vim.keymap.set({ 'n', 'x' }, '<M-q>', function()
  local cpos = vim.api.nvim_win_get_cursor(0)
  local mc_space = vim.api.nvim_create_namespace 'nvim.multicursor'
  local mc_list = mc_below_cursor()

  if #mc_list == 0 then
    -- No cursor to remove, just toggle
    vim.api.nvim_feedkeys('Q', 'nx', false)
  else
    -- Move the cursor and remove the previous one
    local mc = mc_list[1]
    if cpos[1] - 1 == mc[2] and cpos[2] == mc[3] then
      vim.api.nvim_feedkeys(']C', 'nx', false)
      vim.api.nvim_buf_del_extmark(0, mc_space, mc[1])
      clear_gutter()
    end
  end

  add_gutter()
end, { desc = 'Add cursor' })

-- Clear multicursors without using C-L which we already have
-- for switching between windows...
vim.keymap.set('n', '<M-c>', function()
  clear_mc()
end, { desc = 'Clear multicursors' })

-- Add multicursor here and jump to next or previous match of word
-- under cursor. Position initial cursor at the start of the word as well
-- with lb
vim.keymap.set('n', '<M-n>', function()
  if #mc_below_cursor() == 0 then
    vim.api.nvim_feedkeys('lbQ*', 'nx', false)
  else
    vim.api.nvim_feedkeys('*', 'nx', false)
  end
  vim.cmd.nohlsearch()
  add_gutter()
end, { desc = 'Cursor and next match' })
vim.keymap.set('n', '<M-p>', function()
  if #mc_below_cursor() == 0 then
    vim.api.nvim_feedkeys('lbQ#', 'nx', false)
  else
    vim.api.nvim_feedkeys('#', 'nx', false)
  end
  vim.cmd.nohlsearch()
  add_gutter()
end, { desc = 'Cursor and previous match' })
vim.keymap.set('n', '<M-N>', function()
  local put_mcs =
    vim.api.nvim_replace_termcodes('*1Q<C-O>q=', true, false, true)
  vim.api.nvim_feedkeys(put_mcs, 'nx', false)
  vim.cmd.nohlsearch()
  add_gutter()
end, { desc = 'Cursor on all matches ' })

-- Match in visual selection
vim.keymap.set('x', '<M-m>', function()
  -- Ask for match to user
  local match = vim.fn.input { prompt = 'Match: ' }

  local mode = vim.fn.mode()
  local region_pos =
    vim.fn.getregionpos(vim.fn.getpos 'v', vim.fn.getpos '.', { type = mode })

  -- Before anything else, we have to exit visual mode
  local escape_to_normal =
    vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, false, true)
  vim.api.nvim_feedkeys(escape_to_normal, 'nx', false)

  for _, reg_pos in ipairs(region_pos) do
    -- Grab the text region
    local region = vim.fn.getregion(reg_pos[1], reg_pos[2], { type = mode })

    -- Search for matches
    local idx = region[1]:find(match, 1, true)
    while idx do
      -- Define the position for the multicursor from the correct row and
      -- column
      local pos = { reg_pos[1][2], reg_pos[1][3] - 2 + idx }

      -- Add the cursor
      vim.api.nvim_mcursor(0, pos)

      -- Move the main cursor to this position
      vim.api.nvim_win_set_cursor(0, pos)
      idx = region[1]:find(match, idx + 1, true)
    end
  end

  -- Put in follow mode, this will effectively eliminate the last cursor
  -- because the main cursor will be on top.
  vim.api.nvim_feedkeys('q=', 'nx', false)
  add_gutter()
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
      add_gutter()
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
      add_gutter()
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
