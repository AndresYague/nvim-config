require('nvim-autopairs').setup {
  ignored_next_char = '',
}

require('todo-comments').setup {}

require('conform').setup {
  notify_on_error = false,
  format_on_save = nil, -- Do not format on save
}

-- "in-and-out" keymaps
vim.keymap.set('i', '<C-H>', function()
  require('in-and-out').in_and_out()
end)

-- "TODO" search keymaps
vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next todo comment' })
vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous todo comment' })

vim.keymap.set({ 'n' }, '<leader>cf', function()
  require('conform').format {
    async = true,
    lsp_format = 'fallback',
  }
end, { desc = 'Format buffer' })

require('blink.cmp').setup {
  keymap = {
    preset = 'default',
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    list = { selection = { preselect = true, auto_insert = false } },
    ghost_text = { enabled = true },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      snippets = {
        opts = {
          friendly_snippets = true,
        },
      },
    },
  },

  snippets = { preset = 'default' },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = { enabled = true },
}
