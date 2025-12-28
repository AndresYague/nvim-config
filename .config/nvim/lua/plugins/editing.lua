require('nvim-autopairs').setup {
  ignored_next_char = '',
}

require('todo-comments').setup {
  event = 'VimEnter',
  opts = { signs = true },
}

require('conform').setup {
  notify_on_error = false,
  format_on_save = nil, -- Do not format on save
}

require('luasnip.loaders.from_vscode').lazy_load()

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
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
    providers = {
      lazydev = {
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
    },
  },

  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = { enabled = true },
}
