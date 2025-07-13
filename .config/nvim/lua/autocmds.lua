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

-- Change these options for cpp and lua

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'cpp', 'lua' },
  callback = function()
    vim.o.tabstop = 2
    vim.o.shiftwidth = 2
  end,
})

-- Make python add comments on new line
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'python' },
  callback = function()
    vim.o.formatoptions = 'jcroql'
  end,
})

-- Add keybinds for diff mode
vim.api.nvim_create_autocmd({ 'DiffUpdated' }, {
  desc = 'Diff put and fetch keymaps when on diff',
  group = vim.api.nvim_create_augroup('diff-mode', { clear = true }),
  callback = function()
    -- Normal diff keymap, get from other
    vim.api.nvim_buf_set_keymap(
      0,
      'n',
      'go',
      'do',
      { desc = 'Get diff from other window' }
    )
    -- Gvdiffsplit keymaps
    vim.api.nvim_buf_set_keymap(
      0,
      'n',
      'gh',
      '<cmd>diffget //2<CR>',
      { desc = 'Get diff from left merge window' }
    )
    vim.api.nvim_buf_set_keymap(
      0,
      'n',
      'gl',
      '<cmd>diffget //3<CR>',
      { desc = 'Get diff from right merge window' }
    )
  end,
})

-- Folding expressions

local ignore_filetypes_folding =
  { 'gitcommit', 'gitrebase', 'svg', 'hgcommit', 'fugitive' }

vim.api.nvim_create_autocmd({ 'FileType' }, {
  callback = function()
    local filetype = vim.bo.filetype
    if vim.tbl_contains(ignore_filetypes_folding, filetype) then
      return
    end

    if pcall(vim.treesitter.get_parser) then
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    else
      vim.opt.foldmethod = 'syntax'
    end
  end,
})

-- Remember folds
local view_group = vim.api.nvim_create_augroup('auto_view', { clear = true })
vim.api.nvim_create_autocmd(
  { 'BufWinLeave', 'BufWritePost', 'WinLeave', 'BufUnload' },
  {
    desc = 'Save view with mkview for real files',
    group = view_group,
    callback = function(args)
      if vim.b[args.buf].view_activated then
        vim.cmd.mkview { mods = { emsg_silent = true } }
      end
    end,
  }
)
vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Try to load file view if available and enable view saving for real files',
  group = view_group,
  callback = function(args)
    if not vim.b[args.buf].view_activated then
      local filetype =
        vim.api.nvim_get_option_value('filetype', { buf = args.buf })
      local buftype =
        vim.api.nvim_get_option_value('buftype', { buf = args.buf })
      if
        buftype == ''
        and filetype
        and filetype ~= ''
        and not vim.tbl_contains(ignore_filetypes_folding, filetype)
      then
        vim.b[args.buf].view_activated = true
        vim.cmd.loadview { mods = { emsg_silent = true } }
      end
    end
  end,
})
