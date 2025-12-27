require('nvim-autopairs').setup {
  ignored_next_char = '',
}

require('todo-comments').setup {
  event = 'VimEnter',
  opts = { signs = true },
}

-- TODO:
require('conform').setup {
  notify_on_error = false,
  format_on_save = nil, -- Do not format on save
  formatters_by_ft = {
    lua = { 'stylua' },
  },
}

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

-- return {
--   { -- Autoformat
--     'stevearc/conform.nvim',
--     event = { 'BufWritePre' },
--     cmd = { 'ConformInfo' },
--     keys = {
--       {
--         '<leader>cf',
--         function()
--           require('conform').format {
--             async = true,
--             lsp_format = 'fallback',
--           }
--         end,
--         mode = '',
--         desc = 'Format buffer',
--       },
--     },
--     opts = {
--       notify_on_error = false,
--       format_on_save = nil, -- Do not format on save
--       formatters_by_ft = {
--         lua = { 'stylua' },
--       },
--     },
--   },
--
--   { -- Autocompletion
--     'saghen/blink.cmp',
--     event = 'VimEnter',
--     dependencies = {
--       -- Snippet Engine
--       {
--         'L3MON4D3/LuaSnip',
--         build = (function()
--           -- Build Step is needed for regex support in snippets.
--           -- This step is not supported in many windows environments.
--           -- Remove the below condition to re-enable on windows.
--           if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
--             return
--           end
--           return 'make install_jsregexp'
--         end)(),
--         dependencies = {
--           -- `friendly-snippets` contains a variety of premade snippets.
--           --    See the README about individual language/framework/plugin snippets:
--           --    https://github.com/rafamadriz/friendly-snippets
--           {
--             'rafamadriz/friendly-snippets',
--             config = function()
--               require('luasnip.loaders.from_vscode').lazy_load()
--             end,
--           },
--         },
--         opts = {},
--       },
--       'folke/lazydev.nvim',
--     },
--     --- @module 'blink.cmp'
--     --- @type blink.cmp.Config
--     opts = {
--       keymap = {
--         preset = 'default',
--       },
--
--       appearance = {
--         nerd_font_variant = 'mono',
--       },
--
--       completion = {
--         documentation = { auto_show = false, auto_show_delay_ms = 500 },
--       },
--
--       sources = {
--         default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
--         providers = {
--           lazydev = {
--             module = 'lazydev.integrations.blink',
--             score_offset = 100,
--           },
--         },
--       },
--
--       snippets = { preset = 'luasnip' },
--       fuzzy = { implementation = 'lua' },
--       signature = { enabled = true },
--     },
--   },
-- }
