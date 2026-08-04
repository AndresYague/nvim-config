--[[

This plugin requires a "clocks.csv" file that looks like:
This file must be in the neovim configuration path
--------------------------------------------------------

name,effort
test1,07:00
test2,14:00
test3

--]]

-- Use snacks for the picker
local Snacks = require 'snacks'

-- Cached values
local cached_tracker_file = nil
local last_update_time = 0
local last_update_value = nil

-- Filepath to save the clocks
local tracker_file = vim.fs.joinpath(vim.fn.stdpath 'data', 'clocks.csv')
local effort_file = vim.fs.joinpath(vim.fn.stdpath 'config', 'clocks.csv')

---@param time integer?
---@return string
local function formatted_date(time)
  return os.date('%Y/%m/%d %H:%M:%S', time)
end

-- Format the time in seconds into HH:MM
---@param seconds number
---@return string
local function format_time(seconds)
  local sign = seconds < 0 and '-' or ''
  seconds = math.abs(seconds)

  local hours = math.floor(seconds / 3600)
  local minutes = math.floor(seconds % 3600 / 60)

  return string.format('%s%02d:%02d', sign, hours, minutes)
end

-- Transform a HH:MM format into seconds
---@param clock_str string
---@return number?
local function to_seconds(clock_str)
  if clock_str == '' then
    return 0
  end

  local index_colon = clock_str:find ':'

  -- If not a `HH:MM` format, it is minutes
  if index_colon == nil then
    return tonumber(clock_str) * 60
  end

  -- Do we have a negative amount?
  local is_negative = clock_str:sub(1, 1) == '-'
  if is_negative then
    clock_str = clock_str:sub(2)
    index_colon = index_colon - 1
  end

  local hours = tonumber(clock_str:sub(1, index_colon - 1))
  local minutes = tonumber(clock_str:sub(index_colon + 1))
  local seconds = hours * 3600 + minutes * 60

  return is_negative and -seconds or seconds
end

-- Function to read the clocks file
---@return string[]?
local function clocks_lines()
  if cached_tracker_file ~= nil then
    return cached_tracker_file
  end

  -- If the file does not exist, create it
  if vim.fn.filereadable(tracker_file) == 0 then
    local file = io.open(tracker_file, 'w')
    if file then
      file:close()
    end
  end

  cached_tracker_file = vim.fn.readfile(tracker_file)
  return cached_tracker_file
end

-- Function to read the efforts file
---@return string[]?
local function efforts_lines()
  if vim.fn.filereadable(effort_file) == 0 then
    return
  end

  return vim.fn.readfile(effort_file)
end

-- Split the line and return the values
---@param line string
---@return string?, string?, string?
local function split_line(line)
  if #line == 0 then
    return
  end

  local split = line:find ','
  if split == nil then
    return line, nil
  else
    -- If line can be split further, be careful
    local second_split = line:find(',', split + 1) or line:len() + 1
    if second_split == nil then
      return line:sub(1, split - 1), line:sub(split + 1)
    else
      return line:sub(1, split - 1),
        line:sub(split + 1, second_split - 1),
        line:sub(second_split + 1)
    end
  end
end

-- Query the clock file, return a table with the queried clock and the time
-- tallied + elapsed (if it is still running). If the 'all' clock is given,
-- return all existing clocks.
---@param clock_name string
---@return table?
local function read_clock(clock_name)
  local lines = clocks_lines()
  if lines == nil then
    return
  end

  local times_table = {}
  for _, line in ipairs(lines) do
    local label, time = split_line(line)
    if label == nil then
      return
    end

    if clock_name and (clock_name == label or clock_name == 'all') then
      -- Add information to the table
      if times_table[label] then
        times_table[label][#times_table[label] + 1] = time
      else
        times_table[label] = { time }
      end
    end
  end

  -- For each clock return the total time passed so far
  local total_times = {}
  for label, times in pairs(times_table) do
    -- If the number of times is odd, add the current time in the end
    if #times % 2 == 1 then
      times[#times + 1] = os.time()
    end

    -- Collect the time differences
    local dt = 0
    for i, t in ipairs(times) do
      dt = dt + (-1) ^ (i % 2) * t
    end
    total_times[label] = dt
  end

  return total_times
end

-- Get asked for clock / effort
---@param label string
---@return string?
local function effort_clock(label)
  local dt = read_clock(label)[label]

  -- Remember the simple format if we need to use it, because it would be our
  -- last updated value as well most of the time, store it there
  local show_format = dt and format_time(dt) or '00:00'

  -- Get the effort lines (if none, return simple format)
  local elines = efforts_lines()
  if elines == nil then
    return show_format
  end

  -- Find the total effort time in case we have an effort label to show
  local total_eff = 0
  for i, line in ipairs(elines) do
    if i > 1 then
      local elab, eff = split_line(line)
      if elab ~= nil and eff ~= nil then
        local elab_dt = read_clock(elab)[elab]
        if elab_dt ~= nil then
          total_eff = total_eff + elab_dt
        end
      end
    end
  end

  -- If we find the specific effort, show it, otherwise use the simple format
  for i, line in ipairs(elines) do
    if i > 1 then
      local elab, eff = split_line(line)
      if elab == label then
        if eff == nil then
          return show_format
        else
          -- In this case our last update value is the new format
          -- Show the effort if no time has been added either
          show_format = dt
              and ('%s / %s (%s TE)'):format(
                format_time(dt),
                eff,
                format_time(total_eff)
              )
            or ('00:00 / %s (%s TE)'):format(eff, format_time(total_eff))

          return show_format
        end
      end
    end
  end

  -- If reaching here, the line is not in effort. Add it anyway.
  return show_format
end

-- Read information from add_times and notify it in a nice format
---@param clock_name string?
---@return table<string, integer>?
local function notify_clock(clock_name)
  local total_times = assert(read_clock(assert(clock_name)))
  local lines = assert(clocks_lines())
  local last_label = (#lines % 2 == 1) and split_line(lines[#lines]) or ''

  -- Notify the information and indicate the active clock with an asterisk
  for label, _ in pairs(total_times) do
    vim.notify(
      ('%s%s: %s'):format(
        last_label == label and '*' or '',
        label,
        effort_clock(label),
        vim.log.levels.INFO
      )
    )
  end

  -- If a specific clock was asked for, also return all lines where there is
  -- a date specified
  if clock_name ~= 'all' then
    -- Look for all instances of the clock label and retrieve the date
    for _, line in ipairs(lines) do
      local lab, _, date = split_line(line)

      -- If no date information or not the right clock, ignore this line
      if date ~= nil and lab == clock_name then
        -- Strip the line from the last '\n' if it's there
        if date:sub(date:len(), date:len()) == '\n' then
          date = date:sub(1, date:len() - 1)
        end

        -- Notify the date
        vim.notify(date, vim.log.levels.INFO)
      end
    end
  end
end

-- Return the lines for the tracker file by adjusting all effort clocks by
-- generic label proportionally
---@param lines string[]
---@param curr_time number
---@return string[]?
local function adjust_generic(lines, curr_time)
  local e_lines = efforts_lines()
  if e_lines == nil then
    return
  end

  -- Calculate the time from the last two lines
  local flabel, first = split_line(lines[#lines - 1])
  local slabel, second = split_line(lines[#lines])
  assert(slabel == 'generic' and flabel == 'generic')

  -- Now that we have the info, remove the "generic" labels from the list
  -- Slice the table by using unpack
  lines = { unpack(lines, 1, #lines - 2) }

  local dt = second - first

  local total_effort = 0
  local effort_table = {}
  for i, line in ipairs(e_lines) do
    -- Ignore the header
    if i > 1 then
      -- Get values
      local elab, effst = assert(split_line(line))
      if effst ~= nil then
        -- Log the efforts
        local eff = assert(to_seconds(effst))
        total_effort = total_effort + eff
        effort_table[elab] = eff
      end
    end
  end

  -- Calculate proportions and write
  for elab, _ in pairs(effort_table) do
    local prop_effort = math.floor(effort_table[elab] * dt / total_effort)

    -- The trick is to write one line with the current time and another with
    -- the proportional effort
    table.insert(
      lines,
      ('%s,%s,%s gs'):format(elab, curr_time, formatted_date(curr_time))
    )
    table.insert(
      lines,
      ('%s,%s,%s ge'):format(
        elab,
        curr_time + prop_effort,
        formatted_date(curr_time + prop_effort)
      )
    )
  end

  return lines
end

-- Stops the current clock
---@param verbose boolean?
---@return nil
local function stop_clock(verbose)
  -- Make sure the value will be updated immediately
  last_update_value = nil

  local lines = clocks_lines()
  if lines == nil then
    return
  end

  if #lines % 2 == 0 then
    if verbose then
      vim.notify('No active clock', vim.log.levels.INFO)
    end

    return
  end

  local label = split_line(lines[#lines])
  if label ~= nil then
    if verbose then
      vim.notify(
        string.format('Stopping clock: %s', label),
        vim.log.levels.INFO
      )
    end

    -- Save current time for later
    local curr_time = os.time()

    -- Insert the new line in the table
    table.insert(
      lines,
      ('%s,%s,%s e'):format(label, curr_time, formatted_date(curr_time))
    )

    -- If the label is "generic" divide it proportionally by the effort listed
    -- in the effort_file after closing it.
    if label == 'generic' then
      local ret = adjust_generic(lines, curr_time)
      if ret ~= nil then
        lines = ret
      end
    end
  end

  -- Write data
  vim.fn.writefile(lines, tracker_file, 's')

  -- Make the lualine update immediately
  last_update_value = nil
  cached_tracker_file = nil
end

-- Start the named clock
---@param clock_name string
local function start_clock(clock_name)
  -- Make sure the value will be updated immediately
  last_update_value = nil

  -- Stop the previous clock if still going
  stop_clock()

  -- Start the new clock

  -- Check if file exists. If it does not, create it
  if vim.fn.filewritable(tracker_file) == 0 then
    local file = io.open(tracker_file, 'w')
    if file then
      file:close()
    end
  end

  -- Write data
  local curr_time = os.time()
  vim.fn.writefile(
    ('%s,%s,%s s'):format(clock_name, curr_time, formatted_date(curr_time)),
    tracker_file,
    'as'
  )

  -- Make the lualine update immediately
  last_update_value = nil
  cached_tracker_file = nil
end

-- Get active clock / effort
---@param cache_opts { use_cache: boolean, seconds: number}? Whether to cache the output, the delay is in seconds
---@return string?
local function active_clock(cache_opts)
  -- Keep current time
  local curr_time = os.time()

  -- Using cached value if it exists
  if cache_opts and cache_opts.use_cache and last_update_value then
    if (curr_time - last_update_time) < cache_opts.seconds then
      return last_update_value
    end
  end

  -- Otherwise update time, and make sure we will
  -- read the tracker_file
  last_update_time = curr_time
  cached_tracker_file = nil

  --- Return nothing if there is no info
  local lines = clocks_lines()
  if lines == nil or #lines % 2 == 0 then
    last_update_value = ''
    return last_update_value
  end

  -- Try to get the info of the last clock
  local last_lab = assert(split_line(lines[#lines]))
  last_update_value = ('%s %s'):format(last_lab, assert(effort_clock(last_lab)))
  return last_update_value
end

-- Notify the total elapsed time
---@return nil
local function notify_elapsed_time()
  local total_time = 0
  for _, time in pairs(assert(read_clock 'all')) do
    total_time = total_time + time
  end

  vim.notify(
    ('Total time %s'):format(format_time(total_time)),
    vim.log.levels.INFO
  )
end

-- Adjust clocks by an amount in miutes
---@param label string
---@return nil
local function adjust_clock(label)
  -- Deal with input

  -- Give time context for the prompt if possible
  local adjustment
  local context_clock = effort_clock(label)
  if context_clock == nil then
    adjustment = vim.fn.input(('Adjust %s by HH:MM or minutes: '):format(label))
  else
    adjustment = vim.fn.input(
      ('Adjust %s by HH:MM or minutes [%s]: '):format(label, context_clock)
    )
  end

  -- If adjustment is empty, exit
  if #adjustment == '' then
    return
  end

  -- If clock format, transform it
  local add_seconds = to_seconds(adjustment)

  -- If add_minutes it is nil, exit
  if add_seconds == nil or add_seconds == 0 then
    return
  end

  local lines = assert(clocks_lines())
  local last_line
  if #lines % 2 == 1 then
    -- Active clock, save the last line and remove it from the file
    last_line = lines[#lines]
    lines = { unpack(lines, 1, #lines - 1) }
  end

  local curr_time = os.time()
  table.insert(
    lines,
    ('%s,%s,%s s'):format(label, curr_time, formatted_date(curr_time))
  )
  table.insert(
    lines,
    ('%s,%s,%s e'):format(
      label,
      curr_time + add_seconds,
      formatted_date(curr_time + add_seconds)
    )
  )

  -- If the label is "generic", adjust in other clocks
  if label == 'generic' then
    local ret = adjust_generic(lines, curr_time)
    if ret ~= nil then
      lines = ret
    end
  end

  -- If there was an active clock, reinstate it
  if last_line ~= nil then
    table.insert(lines, last_line)
  end

  -- Write data
  vim.fn.writefile(lines, tracker_file, 's')

  -- Make the lualine update immediately
  last_update_value = nil
  cached_tracker_file = nil
end

-- Delete the clocks file
---@return nil
local function clear_clocks()
  -- Make sure the user wants to delete the clocks
  local a = vim.fn.input 'Do you really want to reset all the clocks? (y/[n]): '
  if a ~= 'y' then
    return
  end

  -- Make sure the value will be updated immediately
  last_update_value = nil

  -- Try to delete the file
  local status = vim.fn.delete(tracker_file)

  -- Notify of error
  if status == -1 then
    vim.notify(
      ('Could not delete %s'):format(tracker_file),
      vim.log.levels.ERROR
    )
  end
end

-- Add a new clock
---@return nil
local function add_clock()
  local elines = efforts_lines()

  -- If the file does not exist, create it
  if elines == nil then
    local file = io.open(effort_file, 'w')
    if file then
      file:close()
    end

    -- Write the header on the top of the file
    vim.fn.writefile('name,effort\n', effort_file, 's')
    elines = {}
  end

  local line = vim.fn.input 'Clock name: '
  if line == '' then
    return
  end

  local effort = vim.fn.input 'Effort in HH:MM (optional): '
  line = effort:find ':' and line .. (',%s'):format(effort) or line

  vim.fn.writefile(line .. '\n', effort_file, 'as')
  vim.notify(('Added clock: %s'):format(line), vim.log.levels.INFO)
end

-- Remove a clock
---@param label string
---@return nil
local function remove_clock(label)
  -- If no label provided, get out
  if label == nil then
    return
  end

  -- If no file, get out
  local elines = efforts_lines()
  if elines == nil then
    return
  end

  -- If there is a label, remove it from the lines
  for i, line in ipairs(elines) do
    local lab = split_line(line)
    if lab == label then
      table.remove(elines, i)
      vim.notify(('Removed clock: %s'):format(label), vim.log.levels.INFO)
      break
    end
  end

  -- Save the file
  vim.fn.writefile(elines, effort_file, 's')
end

-- Picker for the clocks
---@param fun function
---@param extra_clocks string[]?
---@return nil
local function clock_selector(fun, extra_clocks)
  local lines = efforts_lines()
  if lines == nil then
    return
  end

  -- Read the effort_file
  local labels = {}

  -- Add the extra_clock option if given
  if extra_clocks then
    for _, extra_clock in ipairs(extra_clocks) do
      table.insert(labels, {
        text = extra_clock,
      })
    end
  end

  for i, line in ipairs(lines) do
    -- Ignore the header
    if i > 1 then
      table.insert(labels, {
        text = split_line(line),
      })
    end
  end

  Snacks.picker.pick {
    items = labels,
    format = 'text',

    -- Overload the dropdown layout to give the preview box a height of 1
    layout = {
      preset = 'dropdown',
      layout = {
        backdrop = false,
        row = 1,

        -- Change also the size of the window
        width = 0.2,
        min_width = 40,
        height = 0.3,

        border = 'none',
        box = 'vertical',

        -- This is the overloaded part
        { win = 'preview', title = '{preview}', height = 1, border = true },

        {
          box = 'vertical',
          border = true,
          title = '{title} {live} {flags}',
          title_pos = 'center',
          { win = 'input', height = 1, border = 'bottom' },
          { win = 'list', border = 'none' },
        },
      },
    },
    preview = function(ctx)
      local label = ctx.item.text
      local label_found = false

      -- If clock in extra_clocks then don't try to
      -- get the effort
      if extra_clocks then
        for _, extra_clock in ipairs(extra_clocks) do
          if extra_clock:find(label) then
            label_found = true
            break
          end
        end
      end

      if label_found then
        ctx.preview:set_lines { nil }
      else
        ctx.preview:set_lines { effort_clock(label) }
      end
    end,
    confirm = function(picker, choice)
      picker:close()
      if choice then
        fun(choice.text)
      end
    end,
  }
end

-- Add clock to lualine

-- Get lualine configuration
local lualine = require 'lualine'
local lualine_config = lualine.get_config()

-- Insert new function into the configuration
table.insert(lualine_config['sections']['lualine_x'], 1, function()
  return active_clock { use_cache = true, seconds = 10 }
end)

-- Call setup again
lualine.setup(lualine_config)

-- Keymaps!

vim.keymap.set('n', '<leader>ki', function()
  clock_selector(start_clock, { 'generic' })
end, { desc = 'Clock in' })

vim.keymap.set('n', '<leader>ko', function()
  stop_clock(true)
end, { desc = 'Clock out' })

vim.keymap.set('n', '<leader>kl', function()
  clock_selector(notify_clock, { 'all' })
end, { desc = 'List clocks' })

vim.keymap.set('n', '<leader>kj', function()
  clock_selector(adjust_clock, { 'generic' })
end, { desc = 'Adjust clocks' })

vim.keymap.set('n', '<leader>kt', function()
  notify_elapsed_time()
end, { desc = 'Total time elapsed' })

vim.keymap.set('n', '<leader>kr', function()
  clear_clocks()
end, { desc = 'Reset clocks' })

vim.keymap.set('n', '<leader>ka', function()
  add_clock()
end, { desc = 'Add clock' })

vim.keymap.set('n', '<leader>kd', function()
  clock_selector(remove_clock)
end, { desc = 'Delete clock' })
