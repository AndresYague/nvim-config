local current_selections = {}
local selection_range = {}
local buffers = {}
local buff_extmarks = {}
local old_func

-- Using the word-diff from gitsigns
local wdiff = require 'gitsigns.diff_int'

-- Extmark namespace
local namespace = vim.api.nvim_create_namespace 'local_diff'

---@return nil
local add_selection = function()
  -- Visually selected region
  local region = vim.fn.getregionpos(vim.fn.getpos "'[", vim.fn.getpos "']")

  -- Get all lines in each sub-region
  local selections = {}
  local ranges = {}
  for _, positions in ipairs(region) do
    -- Save each line whole
    -- the line number is in positions[1][2]
    selections[#selections + 1] = vim.fn.getline(positions[1][2])
    ranges[#ranges + 1] = positions[1][2]
  end

  -- Make sure we always keep the last 2 selections
  if #current_selections == 2 then
    current_selections = { current_selections[2] }
  end
  current_selections[#current_selections + 1] = vim.fn.join(selections, '\n')

  selection_range[#selection_range + 1] = ranges
  buffers[#buffers + 1] = region[1][1][1]
end

---@return nil | table
local diff_selection = function()
  -- Find the differences between the two hukns
  if #current_selections == 2 then
    -- Skip if the selections are identical
    if current_selections[1] == current_selections[2] then
      return
    end

    local diff = vim.text.diff(current_selections[1], current_selections[2], {
      result_type = 'indices',
      ignore_cr_at_eol = true,
      algorithm = 'minimal',
    })
    assert(diff ~= nil)

    local removed = {}
    local added = {}

    local removed_line = {}
    local added_line = {}

    -- Extract added and removed
    assert(type(diff) == 'table')
    for _, hunk in ipairs(diff) do
      removed_line[#removed_line + 1] = { hunk[1], hunk[2] }
      for i = 0, hunk[2] - 1 do
        removed[#removed + 1] =
          vim.fn.split(current_selections[1], '\n')[hunk[1] + i]
      end

      added_line[#added_line + 1] = { hunk[3], hunk[4] }
      for i = 0, hunk[4] - 1 do
        added[#added + 1] =
          vim.fn.split(current_selections[2], '\n')[hunk[3] + i]
      end
    end

    return { { wdiff.run_word_diff(removed, added) }, removed_line, added_line }
  end

  return nil
end

---@param mode string
---@return nil
---@diagnostic disable-next-line: unused-local
_G.diffthis = function(mode)
  -- Get the selections
  add_selection()

  -- Do the diffs
  local diffs = diff_selection()
  if not diffs then
    return nil
  end

  local wd = diffs[1]
  local rem_add = { diffs[2], diffs[3] }

  for i = 1, 2 do
    local changes = wd[i]
    local offset = rem_add[i][1][1] - 1
    local buffnr = buffers[i]

    if buff_extmarks[buffnr] == nil then
      buff_extmarks[buffnr] = {}
    end

    for _, change in ipairs(changes) do
      local lnum = selection_range[i][1] + offset + change[1] - 1
      ---@diagnostic disable-next-line: param-type-mismatch
      local line_len = vim.fn.len(vim.fn.getline(lnum))

      local col_sta = 0
      local col_end = line_len
      if #change > 0 then
        col_sta = change[3] - 1
        col_end = vim.fn.min { change[4] - 1, col_end }

        if col_end == col_sta then
          if col_end < line_len then
            col_end = col_end + 1
          else
            col_sta = col_sta - 1
          end
        end
      end

      table.insert(
        buff_extmarks[buffnr],
        vim.api.nvim_buf_set_extmark(buffnr, namespace, lnum - 1, col_sta, {
          hl_group = 'DiffText',
          virt_text_pos = 'overlay',
          end_col = col_end,
        })
      )
    end
  end

  -- Delete the keymap that was previously defined because we do not need it
  -- anymore
  vim.keymap.del({ 'o' }, 'v')

  -- Restore the old opfunc
  vim.go.opfunc = old_func
end

---@return nil
local diffoff = function()
  for bufnr, extmark_ids in pairs(buff_extmarks) do
    -- If no extmark_ids, continue
    if extmark_ids == nil then
      goto continue
    end

    -- Delete all extmarks in this buffer
    for _, extmark_id in ipairs(extmark_ids) do
      vim.api.nvim_buf_del_extmark(bufnr, namespace, extmark_id)
    end

    ::continue::
  end

  -- Clean all tables
  current_selections = {}
  selection_range = {}
  buffers = {}
  buff_extmarks = {}
end

-- Create keymaps
vim.keymap.set(
  { 'x', 'n' },
  '<leader>dx',
  diffoff,
  { desc = 'Visual diff off' }
)
vim.keymap.set({ 'n', 'x' }, '<leader>dv', function()
  old_func = vim.go.opfunc
  vim.go.opfunc = 'v:lua.diffthis'

  -- Define the keymap in this callback so we have access to this keymap only
  -- here
  vim.keymap.set({ 'o' }, 'v', '<leader>', { desc = 'Visual diff line' })

  return 'g@'
end, { desc = 'Visual diff', expr = true })
