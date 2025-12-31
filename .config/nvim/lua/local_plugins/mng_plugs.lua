local plug_delete = function()
  local line = vim.api.nvim_get_current_line()
  line = line:reverse()
  local index = string.find(line, '/')
  local substring = string.sub(line, 1, index - 1)
  substring = substring:reverse()

  local status = false
  while not status do
    status, _ = pcall(vim.pack.del, { substring })

    -- Shorten the string from the end
    substring = string.sub(substring, 1, -2)
    if substring:len() == 0 then
      break
    end
  end

  if not status then
    vim.notify(
      'Plugin not found - already deleted?',
      vim.log.levels.INFO,
      { title = 'Notify' }
    )
  end
end

-- Keymap to delete plugins
vim.keymap.set('n', '<leader>pd', plug_delete, { desc = 'Delete plugin' })

-- Keymap to update plugins
vim.keymap.set(
  'n',
  '<leader>pu',
  ':lua vim.pack.update()<CR>',
  { desc = 'Update plugins' }
)
