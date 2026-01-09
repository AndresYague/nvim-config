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
      org_agenda_earlier = "h",
      org_agenda_later = "l",
    }
  }
}

require('org-bullets').setup()
