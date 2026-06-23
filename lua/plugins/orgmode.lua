require('orgmode').setup {
  org_agenda_files = '~/orgfiles/**/*',
  org_default_notes_file = '~/orgfiles/notes.org',
  org_use_property_inheritance = false,
  hyperlinks = {
    sources = {},
  },
  org_todo_keywords = { 'TODO', 'WAITING', '|', 'DONE', 'DELEGATED' },
  org_hide_leading_stars = true,
  mappings = {
    agenda = {
      org_agenda_earlier = 'h',
      org_agenda_later = 'l',
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
}

-- Clocks keymaps
-- TODO: Make pickers out of some of these...
vim.keymap.set(
  'n',
  '<leader>kk',
  ':Org agenda c<CR>',
  { desc = 'Access clocks' }
)

vim.keymap.set(
  'n',
  '<leader>kj',
  function ()
    require('orgmode').clock:org_clock_goto()
  end,
  { desc = 'Go to current clock' }
)

vim.keymap.set(
  'n',
  '<leader>ki',
  function ()
    require('orgmode').clock:org_clock_in()
  end,
  { desc = 'Clock in' }
)

vim.keymap.set(
  'n',
  '<leader>ko',
  function ()
    require('orgmode').clock:org_clock_out()
  end,
  { desc = 'Clock out' }
)

vim.keymap.set(
  'n',
  '<leader>kq',
  function ()
    require('orgmode').clock:org_clock_cancel()
  end,
  { desc = 'Cancel clock' }
)


require('org-bullets').setup()
require('org-virtual-clocktime').setup()
