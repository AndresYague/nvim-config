-- Custom functions

-- This function checks for errors from pcall and makes sure we are
-- only ignoring the errors given in the "ignore_table"
---@param ignore_table string[]
---@param success boolean
---@param err_str string?
---@return nil
local ignore_errors = function(ignore_table, success, err_str)
  if not success then
    local err_in_tbl = false
    assert(err_str ~= nil)
    for _, ignore in ipairs(ignore_table) do
      if string.match(err_str, ignore) ~= nil then
        err_in_tbl = true
        break
      end
    end
    if not err_in_tbl then
      error(err_str)
    end
  end
end

-- Clear all terminal buffers when entering neovim
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('Remove terminals', { clear = true }),
  callback = function()

    -- Use vim.schedule to give buffers a chance to load
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf):match 'term://' then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end)
  end,
})

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
          if string.find(vim.api.nvim_buf_get_name(b), match_str) then
            cmd = cmd .. '<cmd>bwipeout ' .. b .. '<CR>'
          end
        end

        return cmd
      end, { expr = true, desc = 'Close the diff windows' })
    end
  end,
  desc = 'Create the fugitive diffsplit keymaps',
})
vim.api.nvim_create_autocmd('BufWinLeave', {
  group = fugitive_group,
  callback = function(event)
    local match_str = 'fugitive://'
    if event.file:sub(1, match_str:len()) == match_str then
      vim.keymap.del('n', 'gh')
      vim.keymap.del('n', 'gl')
      vim.keymap.del('n', 'gq')

      -- Remap the old keymaps
      vim.keymap.set(
        { 'n', 'o', 'x' },
        'gh',
        '0',
        { desc = 'Go to line start' }
      )
      vim.keymap.set({ 'n', 'o', 'x' }, 'gl', '$', { desc = 'Go to line end' })
    end
  end,
  desc = 'Clear the fugitive diffsplit keymaps',
})

-- Restore diffmode keymap for dp
vim.api.nvim_create_autocmd('DiffUpdated', {
  group = vim.api.nvim_create_augroup('diff-commands', {
    clear = true,
  }),
  callback = function()
    if vim.o.diff then
      ignore_errors({ 'No such mapping' }, pcall(vim.keymap.del, 'o', 'p'))
    else
      vim.keymap.set('o', 'p', '}', { desc = 'Next empty line' })
    end
  end,
  desc = 'Clear or add p as operator mode',
})

-- Loadview for this file if it exists
local loadview_g = vim.api.nvim_create_augroup('Loadview', { clear = true })
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = loadview_g,
  pattern = '?*',
  command = 'silent! loadview',
  desc = 'Load this buffer view if it exists',
})
vim.api.nvim_create_autocmd({ 'BufUnload', 'BufWinLeave' }, {
  group = loadview_g,
  pattern = '?*',
  callback = function(event)
    -- Only save position if this is an actual file
    if
      vim.uv.fs_stat(event.file) and vim.uv.fs_stat(event.file).type == 'file'
    then
      -- If the buffer is a file but without filename, ingore the error
      local ret, status = pcall(vim.cmd.mkview)
      if not ret and status:match 'No file name' == -1 then
        error(status)
      end
    end
  end,
  desc = 'Save this buffer view',
})

-- Create registers keymaps
---@param letter string Register name
local register_keymap = function(letter)
  vim.keymap.set('n', '<leader>m' .. letter, function()
    vim.notify(
      vim.fn.getreg(letter),
      vim.log.levels.INFO,
      { title = 'Register ' .. letter .. ': ' }
    )
  end, { desc = 'Echo @' .. letter })
end

local register_aug = vim.api.nvim_create_augroup('Registers', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = register_aug,
  callback = function()
    ('abcdefghijklmnopqrstuvwxyz'):gsub('.', function(letter)
      if vim.fn.getreg(letter):len() > 0 then
        register_keymap(letter)
      end
    end)
  end,
})
vim.api.nvim_create_autocmd('RecordingLeave', {
  group = register_aug,
  callback = function()
    local letter = vim.fn.reg_recording()
    if vim.fn.getreg(letter):len() > 0 then
      register_keymap(letter)
    end
  end,
})
