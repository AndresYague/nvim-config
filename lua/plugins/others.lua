require('persistence').setup {
  event = 'BufReadPre', -- this will only start session saving when an actual file was opened
}
require('print-debug').setup {}
require('fish-files').setup()

require('colorizer').setup({ '*' }, {
  RRGGBBAA = true, -- #RRGGBBAA hex codes
  css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
  mode = 'background',
})

require('flash').setup {
  label = { style = 'overlay', rainbow = { enabled = true } },
  modes = {
    char = {
      -- jump_labels = true,
      char_actions = function( --[[motion]])
        return {
          [','] = 'next',
          [';'] = 'prev',
          -- If removing these motions, pressing f again does not advance
          -- the search
          -- [motion:lower()] = "next",
          -- [motion:upper()] = "prev",
        }
      end,
    },
  },
}

require('no-neck-pain').setup {
  mappings = {
    -- Set up the toggling map
    enabled = true,
    toggle = '<leader>up',
  },
}


require('nvim-autopairs').setup {}

require('todo-comments').setup {}

-- "TODO" search keymaps
vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next todo comment' })
vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous todo comment' })

-- "in-and-out" keymaps
vim.keymap.set('i', '<C-H>', function()
  require('in-and-out').in_and_out()
end)

-- Persistence keymaps
-- Close current session
vim.keymap.set('n', '<leader>qq', function()
  -- Disable no-neck-pain if it was enabled
  local np_state = require('no-neck-pain').state
  if np_state and np_state.enabled then
    require('no-neck-pain').disable()
  end

  for _, win_id in ipairs(vim.api.nvim_list_wins()) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win_id))
    -- If bufname is empty, this window will be closed
    if bufname:len() == 0 then
      -- Close non-file window
      vim.api.nvim_win_close(win_id, true)
    end
  end

  -- Save the session before quitting
  require('persistence').save()
  vim.cmd.qa()
end, { desc = 'Quit current session' })
-- load the session for the current directory
vim.keymap.set('n', '<leader>qs', function()
  require('persistence').load()
end, { desc = 'Load session in the current directory' })
-- select a session to load
vim.keymap.set('n', '<leader>qS', function()
  require('persistence').select()
end, { desc = 'Select session to load' })
-- load the last session
vim.keymap.set('n', '<leader>ql', function()
  require('persistence').load { last = true }
end, { desc = 'Load last session' })
-- select a session to delete
vim.keymap.set('n', '<leader>qd', function()
  require('persistence').delete()
end, { desc = 'Select session to delete' })
-- stop Persistence => session won't be saved on exit
vim.keymap.set('n', '<leader>qn', function()
  require('persistence').stop()
end, { desc = 'Do not save session' })

-- Restart keymap
vim.keymap.set('n', '<leader>qr', function()
  -- Check every window and close the non file ones
  -- this fixes an issue with file-explorer creating
  -- windows again
  local explorer_was_open = false
  for _, win_id in ipairs(vim.api.nvim_list_wins()) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win_id))
    local buftype = vim.api.nvim_get_option_value(
      'buftype',
      { buf = vim.api.nvim_win_get_buf(win_id) }
    )
    -- If bufname is empty or buftype is "nofile", this window will be closed
    if bufname:len() == 0 or buftype:match 'nofile' then
      -- Check for window titles in this bufname. Because snacks explorer
      -- names one of the windows "Explorer", this allows us to figure out if
      -- the explorer was indeed open, and make it open again upon restart
      local titles = vim.api.nvim_win_get_config(win_id).title
      if titles then
        for _, name in pairs(titles) do
          if name[1] == 'Explorer' then
            explorer_was_open = true
          end
        end
      end

      -- Close non-file window
      vim.api.nvim_win_close(win_id, true)
    end
  end

  -- Do not break backwards compatibility. NOTE: Requires persistence.
  local cmd_restart = nil
  if vim.fn.has 'nvim-0.12.5' == 0 then
    cmd_restart = "lua require('persistence').load();"
  end

  if explorer_was_open then
    cmd_restart = (cmd_restart or 'lua ') .. "require('snacks').explorer();"
  end

  local no_neck = require 'no-neck-pain'
  if no_neck.state and no_neck.state.enabled then
    -- Close no-neck-pain and open it on the way back
    no_neck.disable()
    cmd_restart = (cmd_restart or 'lua ') .. "require('no-neck-pain').toggle()"
  end

  vim.cmd.restart(cmd_restart)
end, { desc = 'Restart session' })

-- Flash keymaps
vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
  require('flash').jump()
end, { desc = 'Flash' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
  require('flash').treesitter()
end, { desc = 'Flash Treesitter' })
vim.keymap.set('o', 'r', function()
  require('flash').remote()
end, { desc = 'Remote Flash' })
vim.keymap.set({ 'o', 'x' }, 'R', function()
  require('flash').treesitter_search()
end, { desc = 'Treesitter Search' })

-- Fish-files keymaps
vim.keymap.set(
  'n',
  '<leader>ja',
  require('fish-files').add_hook,
  { desc = 'Hook this file' }
)
vim.keymap.set(
  'n',
  '<leader>jd',
  require('fish-files').remove_hook,
  { desc = 'Unhook this file' }
)
vim.keymap.set(
  'n',
  '<leader>jm',
  require('fish-files').manage_hooks,
  { desc = 'Manage hooks' }
)
vim.keymap.set(
  'n',
  '<leader>jr',
  require('fish-files').unhook_all_files,
  { desc = 'Unhook all files' }
)
