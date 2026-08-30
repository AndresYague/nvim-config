require('orgmode').setup {
  org_agenda_files = '~/Dropbox/orgfiles/**/*',
  org_default_notes_file = '~/Dropbox/orgfiles/notes.org',
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

  -- Split window control for orgmode
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
  directory = '~/Dropbox/orgfiles/roam',
}

require('org-bullets').setup()

-- Open todos if dashboard still open
vim.schedule(function()
  if vim.o.filetype == 'snacks_dashboard' then
    local dashboard_win = vim.api.nvim_get_current_win()

    -- Count how many TODOs we have.
    local are_there_todos = false
    for _, file in ipairs(require('orgmode.api').load()) do
      for _, headline in ipairs(file.headlines) do
        if headline.todo_type == 'TODO' then
          are_there_todos = true
          goto exit_loops
        end
      end
    end

    ::exit_loops::

    -- Only open if the agenda has todo items at all
    if are_there_todos then
      -- Open org agenda
      vim.cmd 'Org agenda t'

      -- Remove line numbers in this window
      vim.wo.number = false
      vim.wo.relativenumber = false
    end

    vim.schedule(function()
      if vim.api.nvim_win_is_valid(dashboard_win) then
        vim.api.nvim_set_current_win(dashboard_win)
      end
    end)
  end
end)
