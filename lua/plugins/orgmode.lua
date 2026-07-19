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
  directory = '~/orgfiles/roam',
}

require('org-bullets').setup()
