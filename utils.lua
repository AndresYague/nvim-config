M = {}

-- This function checks for errors from pcall and makes sure we are
-- only ignoring the errors given in the "ignore_table"
---@param ignore_table string[]
---@param success boolean
---@param error string?
---@return nil
M.ignore_errors = function(ignore_table, success, error)
  if not success then
    assert(error ~= nil)
    for _, ignore in ipairs(ignore_table) do
      local match = string.match(error, ignore)
      if match == nil then
        error(error)
      end
    end
  end
end

return M
