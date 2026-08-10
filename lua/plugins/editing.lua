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

vim.keymap.set({ 'n', 'x' }, '<leader>cf', function()
  vim.lsp.buf.format()
end, { desc = 'Format buffer' })

local cmp = require 'cmp'
local luasnip = require 'luasnip'

-- Load friendly_snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered { border = 'rounded' },
    documentation = cmp.config.window.bordered { border = 'rounded' },
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm { select = true },
    ['<CR>'] = cmp.mapping.confirm { select = true },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'lazydev', group_index = 0 }, -- Set index to 0 to bypass standard LuaLS duplicates
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
    { name = 'path' },
    { name = 'omni' },
  }),
}

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'buffer' },
  },
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
  matching = {
    disallow_symbol_nonprefix_matching = false,
    disallow_fullfuzzy_matching = false,
    disallow_fuzzy_matching = false,
    disallow_partial_fuzzy_matching = false,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = false,
  },
})
