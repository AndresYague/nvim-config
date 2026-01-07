-- Custom functions

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Folding expressions and indents

local ignore_filetypes_folding =
  { 'gitcommit', 'gitrebase', 'svg', 'hgcommit', 'fugitive' }

vim.api.nvim_create_autocmd({ 'FileType' }, {
  callback = function()
    if vim.tbl_contains(ignore_filetypes_folding, vim.bo.filetype) then
      return
    end

    if pcall(vim.treesitter.get_parser) then
      vim.treesitter.start()
      vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.opt.foldmethod = 'expr'
      vim.opt.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    else
      vim.opt.foldmethod = 'syntax'
    end
  end,
})

-- fugitive keybinds with autocmd
local fugitive_group = vim.api.nvim_create_augroup('fugitive-commands', {
  clear = true,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = fugitive_group,
  callback = function(event)
    local match_str = 'fugitive:///'
    if event.file:sub(1, match_str:len()) == match_str then
      vim.keymap.set('n', 'gh', function()
        return '<cmd>diffget //2<CR>'
      end, { expr = true, desc = 'Get diff from left merge window' })
      vim.keymap.set('n', 'gl', function()
        return '<cmd>diffget //3<CR>'
      end, { expr = true, desc = 'Get diff from right merge window' })
      vim.keymap.set('n', 'gq', function()
        local cmd = ''
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          if string.find(vim.api.nvim_buf_get_name(b), 'fugitive://') then
            cmd = cmd .. '<cmd>bwipeout ' .. b .. '<CR>'
          end
        end

        return cmd
      end, { expr = true, desc = 'Close the diff windows' })
    end
  end,
})
vim.api.nvim_create_autocmd('BufWinLeave', {
  group = fugitive_group,
  callback = function(event)
    local match_str = 'fugitive:///'
    if event.file:sub(1, match_str:len()) == match_str then
      vim.keymap.del('n', 'gl')
      vim.keymap.del('n', 'gq')
    end
  end,
})
