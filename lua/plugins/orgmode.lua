require('orgmode').setup {
  org_agenda_files = '~/orgfiles/**/*',
  org_default_notes_file = '~/orgfiles/notes.org',
  org_use_property_inheritance = false,
  ui = {
    input = {
      use_vim_ui = true,
    },
  },
  hyperlinks = {
    sources = {},
  },
  org_todo_keywords = { 'TODO(t)', 'WAITING', '|', 'DONE', 'DELEGATED(g)' },
  org_hide_leading_stars = true,
  mappings = {
    org = {
      org_add_note = '<leader>on',
    },
    agenda = {
      org_agenda_earlier = 'h',
      org_agenda_later = 'l',
      org_agenda_add_note = '<leader>on',
    },
  },

  -- Define an agenda item for the clocks
  org_agenda_custom_commands = {
    c = {
      description = 'Clocks',
      types = {
        {
          type = 'tags',
          match = 'clocks',
        },
      },
    },
  },

  win_split_mode = function(name)
    -- Make sure it's not a scratch buffer by passing false as 2nd argument
    local bufnr = vim.api.nvim_create_buf(false, false)
    --- Setting buffer name is required
    vim.api.nvim_buf_set_name(bufnr, name)

    local prct = 0.15
    local height = math.floor((vim.o.lines * prct))

    vim.api.nvim_open_win(bufnr, true, {
      height = height,
      split = 'below',
    })
  end,
}

require('org-roam').setup {
  directory = '~/orgfiles/roam',
}

require('org-bullets').setup()
require('org-virtual-clocktime').setup()

-- Clocks keymaps
vim.keymap.set('n', '<leader>kk', function()
  require('orgmode.api.agenda').tags { match_query = 'clocks' }
end, { desc = 'Access clocks' })

-- Clocks search
vim.keymap.set('n', '<leader>ks', function()
  require('orgmode.api.agenda').open_by_key 's'
end, { desc = 'Search clock by keyword' })

vim.keymap.set('n', '<leader>kj', function()
  require('orgmode').clock:org_clock_goto()
end, { desc = 'Go to current clock' })

vim.keymap.set('n', '<leader>ki', function()
  require('orgmode').clock:org_clock_in()
end, { desc = 'Clock in' })

-- Go to the current clock and execute "func" in it, then save the file and
-- come back. If there is no current clock, do nothing.
---@param callable function?
local go_save_return = function(callable)
  -- Record current buffer
  local start_buf = vim.api.nvim_get_current_buf()
  local is_orgfile = vim.api.nvim_buf_get_name(start_buf):match '%.org' ~= nil

  -- Go to clock
  require('orgmode').clock:org_clock_goto()

  -- If we stay in current buffer, end here, unless we were already in the
  -- org file
  if start_buf == vim.api.nvim_get_current_buf() and not is_orgfile then
    return nil
  end

  -- Call the passed function
  if callable ~= nil then
    callable()
  end

  -- Save file and come back, but only if we were not in an org file before
  vim.cmd 'update'

  if not is_orgfile then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('<C-o>', true, false, true),
      'n',
      false
    )
  end
end

vim.keymap.set('n', '<leader>ko', function()
  go_save_return(function()
    require('orgmode').clock:org_clock_out()
  end)
end, { desc = 'Clock out' })

vim.keymap.set('n', '<leader>kq', function()
  go_save_return(function()
    require('orgmode').clock:org_clock_cancel()
  end)
end, { desc = 'Cancel clock' })

vim.keymap.set('n', '<leader>kr', function()
  go_save_return()
end, { desc = 'Refresh clock' })
