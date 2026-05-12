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

vim.keymap.set({ 'n' }, '<leader>cf', function()
  vim.lsp.buf.format { async = true }
end, { desc = 'Format buffer' })

require('blink.cmp').setup {
  keymap = {
    preset = 'default',
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
      window = { border = 'rounded' },
    },
    list = { selection = { preselect = true, auto_insert = false } },
    ghost_text = { enabled = true },
    menu = { border = 'rounded' },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
    providers = {
      lazydev = {
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
      snippets = {
        opts = {
          friendly_snippets = true,
        },
      },
    },
  },

  snippets = { preset = 'default' },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = {
    enabled = true,
    window = { border = 'rounded' },
  },
}
