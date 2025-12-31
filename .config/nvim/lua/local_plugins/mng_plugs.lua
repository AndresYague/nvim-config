-- Parse a plugin string to retrieve something close to the name
---@param plug_str string
---@return string
local plug_name_parse = function(plug_str)
  -- Reverse string so we can easily find the last forward slash
  plug_str = plug_str:reverse()
  local substring = plug_str:sub(1, string.find(plug_str, '/') - 1)

  -- Turn it back to normal
  substring = substring:reverse()

  -- Remove commas and quotation marks
  substring = substring:gsub('"', '')
  substring = substring:gsub("'", '')
  substring = substring:gsub(',', '')

  -- If ".git" in string, remove
  substring = substring:gsub('%.git', '')

  -- Reverse and return
  return substring
end

-- This function calls vim.pack.del on a plugin which name is contained in
-- plug_str, if no string is given, it uses the line where the cursor is
-- located. It does not know about comments.
---@param plug_str string?
---@return nil
local plug_delete = function(plug_str)
  if not plug_str then
    plug_str = vim.api.nvim_get_current_line()
  end

  local substring = plug_name_parse(plug_str)
  local status, _ = pcall(vim.pack.del, { substring })

  if not status then
    vim.notify(
      'Plugin not found - already deleted?',
      vim.log.levels.INFO,
      { title = 'Notify' }
    )
  end
end

-- Find all plugins "added" in the file via "vim.pack.add"
---@param file_name string?
---@return table{string}
local find_plugins_file = function(file_name)
  -- Explore the file to find plugins
  local lines = nil
  if not file_name then
    lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  else
    -- FIXME: Implement
    error 'Not implemented yet!'
  end

  local in_pack_add = false
  local match = { left = nil, right = nil, index = 0 }
  local plugin_names = {}
  for _, line in ipairs(lines) do
    if line:find 'vim.pack.add' then
      if line:find 'vim.pack.add%s*%(' then
        match.left = '%('
        match.right = '%)'
      elseif line:find 'vim.pack.add%s*%{' then
        match.left = '%{'
        match.right = '%}'
      else
        error 'vim.pack.add not found, doing nothing'
      end

      match.index = 1
      in_pack_add = true
      goto continue
    end

    if in_pack_add then
      if line:find(match.left) then
        match.index = match.index + 1
      elseif line:find(match.right) then
        match.index = match.index - 1
      elseif line:find '[%a%p]+/[%a%p]+' then
        table.insert(plugin_names, plug_name_parse(line))
      end

      if match.index == 0 then
        in_pack_add = false
      end
    end
    ::continue::
  end

  return plugin_names
end

-- This function attempts to sync plugins loaded with plugins in vim.pack.add,
-- assuming that all plugins are added in a single file. If a plugin is loaded
-- but not in vim.pack.add, it will delete it.
-- If no file_name is given, it will use the current file
---@param file_name string?
---@return nil
local plug_sync = function(file_name)
  -- Get the plugin table
  local loaded_plugins = vim.pack.get()

  -- Find all plugins in file
  local plugins_in_file = find_plugins_file(file_name)

  -- For every plugin in  loaded_plugins, check if it is in plugins_in_file
  -- if not, remove it
  for _, plugin_table in ipairs(loaded_plugins) do
    local found = false
    for _, plugin in ipairs(plugins_in_file) do
      if plugin_table.spec.name == plugin then
        found = true
        break
      end
    end

    if not found then
      vim.pack.del { plugin_table.spec.name }
    end
  end
end

-- Keymap to delete plugin under the cursor
vim.keymap.set(
  'n',
  '<leader>pd',
  plug_delete,
  { desc = 'Delete plugin under cursor' }
)

-- Keymap to update plugins
vim.keymap.set('n', '<leader>pu', vim.pack.update, { desc = 'Update plugins' })

-- Keymap to sync plugins
vim.keymap.set('n', '<leader>ps', function()
  -- plug_sync(vim.fn.stdpath 'config' .. '/lua/packages.lua') -- FIXME: Not implemented
  plug_sync()
end, { desc = 'Sync plugins' })
