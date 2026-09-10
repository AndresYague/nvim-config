M = {}

-- Add gutter visual info on where there are new cursors

-- This is the sign
vim.fn.sign_define('mc_gutter', { text = '|', texthl = 'CursorLineSign' })

-- Create the namespace for all below
_ = vim.api.nvim_create_namespace 'mc_gutter'

-- Keep track of all the signs so we can remove them easily
local all_signs = {}

M.add_gutter = function()
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

M.clear_gutter = function()
  -- Remove all signs first
  vim.fn.sign_unplacelist(all_signs)
  all_signs = {}
end

vim.api.nvim_create_autocmd('CursorHold', {
  group = vim.api.nvim_create_augroup('MC_gutter', { clear = true }),
  callback = function()
    M.clear_gutter()
    M.add_gutter()
  end,
})

return M
