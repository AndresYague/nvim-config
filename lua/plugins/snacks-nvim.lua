local Snacks = require 'snacks'
local devicons = require 'nvim-web-devicons'

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
      local match = string.match(err_str, ignore)
      if match ~= nil then
        err_in_tbl = true
        break
      end
    end
    if not err_in_tbl then
      error(err_str)
    end
  end
end

Snacks.setup {
  -- Deactivates things for files too large
  bigfile = { enabled = true },

  -- Initial neovim dashboard
  dashboard = {
    enabled = true,
    preset = {
      keys = {
        {
          icon = ' ',
          key = 'f',
          desc = 'Find File',
          action = ":lua Snacks.dashboard.pick('files')",
        },
        {
          icon = ' ',
          key = '/',
          desc = 'Find Text',
          -- Use my own filter_type picker here as well
          action = function()
            Snacks.picker.grep {
              win = {
                input = {
                  keys = {
                    ['<c-t>'] = { 'filter_type', mode = { 'i', 'n' } },
                  },
                },
              },
            }
          end,
        },
        {
          icon = '󰸗 ',
          key = 'a',
          desc = 'Orgmode Agenda',
          action = ':Org agenda a',
        },
        {
          icon = ' ',
          key = 't',
          desc = 'Orgmode Todo',
          action = ':Org agenda t',
        },
        {
          icon = '󰎜 ',
          key = 'c',
          desc = 'Orgmode Capture task',
          action = ':Org capture t',
        },
        {
          icon = ' ',
          key = 'l',
          desc = 'Oil',
          action = ':Oil',
        },
        {
          icon = ' ',
          key = 'n',
          desc = 'New file',
          action = ':new | only',
        },
        {
          icon = ' ',
          key = 's',
          desc = 'Restore Session',
          action = ":lua require('persistence').load()",
        },
        {
          icon = '󰄱 ',
          key = 'i',
          desc = 'Intro',
          action = ':intro',
        },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa!' },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
    },
  },

  -- File explorer
  explorer = { enabled = true },
  -- Render images
  image = { enabled = true },
  -- Indent lines
  indent = { enabled = true, chunk = { enabled = true } },
  -- Load file as fast as possible
  quickfile = { enabled = true },
  -- Rename files
  rename = { enabled = true },

  -- Scope jumps
  scope = {
    enabled = true,
    treesitter = {
      blocks = {
        'function_declaration',
        'function_definition',
        'method_declaration',
        'method_definition',
        'class_declaration',
        'class_definition',
        'do_statement',
        'while_statement',
        'repeat_statement',
        'if_statement',
        'for_statement',
      },
      -- these treesitter fields will be considered as blocks
      field_blocks = {
        'argument_list',
        'arguments',
        'case_statement',
        'catch_clause',
        'class_specifier',
        'comment',
        'dictionary',
        'dictionary_comprehension',
        'enum_specifier',
        'for_range_loop',
        'generator_expression',
        'gnu_asm_expression',
        'import_from_statement',
        'initializer_list',
        'lambda_expression',
        'list',
        'list_comprehension',
        'local_declaration',
        'match_statement',
        'namespace_definition',
        'parameters',
        'parenthesized_expression',
        'preproc_elif',
        'preproc_else',
        'preproc_function_def',
        'preproc_if',
        'preproc_ifdef',
        'preproc_include',
        'set',
        'set_comprehension',
        'string',
        'struct_specifier',
        'switch_statement',
        'table_constructor',
        'template_declaration',
        'try_statement',
        'tuple',
        'with_statement',
      },
    },
  },

  -- Better notifications
  notifier = { enabled = false },
  -- Smooth scrolling
  scroll = { enabled = true },
  -- Status column on its own so that we do not cover the symbols for todo-nvim
  statuscolumn = { enabled = true },
  -- Toggle things
  toggle = { enabled = true },
  -- Terminal
  terminal = { enabled = false },
  -- Zen/Zoom mode
  zen = { enabled = true },

  -- Pickers
  picker = {
    enabled = true,
    win = {
      input = {
        keys = {
          ['<c-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
          ['<c-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
        },
      },
      list = {
        keys = {
          ['<c-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
          ['<c-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
        },
      },
    },
    actions = {
      filter_type = function(picker)
        local get_rg_types = function()
          -- Get the rg --type-list
          local list = vim.api.nvim_cmd({
            cmd = '!',
            args = { 'rg --type-list' },
            mods = { silent = true },
          }, { output = true })

          -- Construct the list
          local file_types = { 'all' }
          for type in string.gmatch(list, '\n%w+:') do
            type = string.sub(type, 2, string.len(type) - 1)
            file_types[#file_types + 1] = type
          end

          -- Return the file_types list
          return file_types
        end

        Snacks.picker.select(
          get_rg_types(),
          { prompt = 'Filter pattern: ' },
          function(choice)
            -- User canceled
            if not choice then
              return
            end

            -- If the choice is all, handle it properly
            if choice == 'all' then
              picker.opts.prompt = ' '
              ---@diagnostic disable-next-line: inject-field
              picker.opts.ft = {}
            else
              local icon = devicons.get_icon_by_filetype(choice, {})

              if icon then
                picker.opts.prompt = icon .. '  '
              else
                picker.opts.prompt = choice .. ' '
              end
              ---@diagnostic disable-next-line: inject-field
              picker.opts.ft = choice
            end
          end
        )
      end,
    },
  },
}

-- Disable animations by default
vim.g.snacks_animate = false

-- Local variables for toggles
local visual_bold = false
local match_parens = false
local old_highlight = nil

vim.api.nvim_create_autocmd('User', {
  callback = function()
    -- Setup some globals for debugging (lazy-loaded)
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    vim.print = _G.dd -- Override print to use snacks for `:=` command

    -- Create some toggle mappings
    Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
    Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uW'
    Snacks.toggle
      .option('relativenumber', { name = 'Relative Number' })
      :map '<leader>uL'
    Snacks.toggle.diagnostics():map '<leader>ud'
    Snacks.toggle.line_number():map '<leader>ul'
    Snacks.toggle
      .option('conceallevel', {
        off = 0,
        on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
      })
      :map '<leader>uc'
    Snacks.toggle.treesitter():map '<leader>uT'
    Snacks.toggle.inlay_hints():map '<leader>uh'
    Snacks.toggle.indent():map '<leader>ug'
    Snacks.toggle.dim():map '<leader>uD'
    Snacks.toggle.animate():map '<leader>ua'
    Snacks.toggle
      .option('cursorline', { name = 'Cursor Line' })
      :map '<leader>ur'
    Snacks.toggle
      .option('cursorcolumn', { name = 'Cursor Column' })
      :map '<leader>uR'

    -- Toggle context
    Snacks.toggle
      .new({
        id = 'treesitter-context',
        name = 'Treesitter Context',
        get = function()
          return require('treesitter-context').enabled()
        end,
        set = function()
          require('treesitter-context').toggle()
        end,
      })
      :map '<leader>ut'

    -- Toggle autopairs
    Snacks.toggle
      .new({
        id = 'nvim-autopairs',
        name = 'Autopairs',
        get = function()
          return not require('nvim-autopairs').state.disabled
        end,
        set = function()
          require('nvim-autopairs').toggle()
        end,
      })
      :map '<leader>uP'

    -- Toggle git blame
    Snacks.toggle
      .new({
        id = 'gitsigns-blame',
        name = 'Gitsigns Blame',
        get = function()
          return require('gitsigns.config').config.current_line_blame
        end,
        set = function()
          require('gitsigns').toggle_current_line_blame()
        end,
      })
      :map '<leader>ub'

    -- Toggle Markview
    Snacks.toggle
      .new({
        id = 'markview',
        name = 'Markview',
        get = function()
          local buffer = vim.api.nvim_get_current_buf()
          if not require('markview.state').buf_attached(buffer) then
            -- Suppress treesitter errors from markview
            ignore_errors(
              { 'Parser could not be created' },
              pcall(require('markview.commands').attach, buffer)
            )
            ignore_errors(
              { 'Parser could not be created' },
              pcall(require('markview.commands').disable, buffer)
            )
          end
          return require('markview.state').get_buffer_state(buffer, false).enable
        end,
        set = function()
          local buffer = vim.api.nvim_get_current_buf()
          require('markview.commands').toggle(buffer)
        end,
      })
      :map '<leader>uM'

    -- Fully custom toggle for colorizer
    Snacks.toggle
      .new({
        id = 'colorizer',
        name = 'Colorizer',
        get = function()
          return require('colorizer').is_buffer_attached(0)
        end,
        set = function()
          vim.cmd 'ColorizerToggle'
        end,
      })
      :map '<leader>uz'

    -- Toggle for gitsigns
    Snacks.toggle
      .new({
        id = 'gitsigns-word-diff',
        name = 'Word diff',
        get = function()
          return require('gitsigns.config').config.word_diff
        end,
        set = function()
          require('gitsigns').toggle_word_diff()
        end,
      })
      :map '<leader>uw'

    -- Toggle for codelens
    Snacks.toggle
      .new({
        id = 'codelens',
        name = 'Codelens',
        get = function()
          return vim.lsp.codelens.is_enabled()
        end,
        set = function(is_disabled)
          if is_disabled then
            vim.lsp.codelens.enable(true)
          else
            vim.lsp.codelens.enable(false)
          end
        end,
      })
      :map '<leader>uk'

    -- Fully custom toggle for visual_bold
    Snacks.toggle
      .new({
        id = 'visual_bold',
        name = 'Visual Bold',
        get = function()
          return visual_bold
        end,
        set = function(is_disabled)
          if is_disabled then
            vim.cmd.highlight {
              args = { 'link Visual IncSearch' },
              bang = true,
            }
          else
            vim.cmd.highlight { args = { 'link Visual NONE' } }
          end

          -- Toggle the flag
          visual_bold = not visual_bold
        end,
      })
      :map '<leader>uV'

    -- Fully custom toggle for match_parens
    Snacks.toggle
      .new({
        id = 'match_parens',
        name = 'Match Parens',
        get = function()
          return match_parens
        end,
        set = function(is_disabled)
          if is_disabled then
            old_highlight = vim.api.nvim_get_hl(0, { name = 'MatchParen' })
            vim.api.nvim_set_hl(0, 'MatchParen', {
              reverse = true,
              update = true,
            })
          else
            assert(old_highlight)
            vim.api.nvim_set_hl(0, 'MatchParen', old_highlight)
          end

          -- Toggle the flag
          match_parens = not match_parens
        end,
      })
      :map '<leader>um'

    -- Toggle for virtual edit
    Snacks.toggle
      .new({
        id = 'virtual_edit',
        name = 'Virtual Edit',
        get = function()
          return vim.o.virtualedit == 'all'
        end,
        set = function(is_disabled)
          if is_disabled then
            vim.o.virtualedit = 'all'
          else
            vim.o.virtualedit = ''
          end
        end,
      })
      :map '<leader>uv'
  end,
})

vim.keymap.set('n', '<C-w>z', function()
  Snacks.zen()
end, { desc = 'Toggle Zen Mode' })
vim.keymap.set('n', '<C-w>m', function()
  Snacks.zen.zoom()
end, { desc = 'Toggle Zoom' })
vim.keymap.set('n', '<leader>cR', function()
  Snacks.rename.rename_file()
end, { desc = 'Rename File' })
vim.keymap.set({ 'n', 'v' }, '<leader>gB', function()
  Snacks.gitbrowse()
end, { desc = 'Git Browse' })
vim.keymap.set('n', '<leader>uu', function()
  require('undotree').open()
end, { desc = 'Toggle Undotree window' })

-- Autocmds for match_parens
local paren_group =
  vim.api.nvim_create_augroup('MatchParenGroup', { clear = true })

-- This clears the previous colorscheme change before modifying the colorscheme
vim.api.nvim_create_autocmd('ColorSchemePre', {
  group = paren_group,
  callback = function()
    if match_parens then
      assert(old_highlight)
      vim.api.nvim_set_hl(0, 'MatchParen', old_highlight)
      match_parens = false
    end
  end,
})
vim.api.nvim_create_autocmd('ColorScheme', {
  group = paren_group,
  callback = function()
    old_highlight = vim.api.nvim_get_hl(0, { name = 'MatchParen' })
    vim.api.nvim_set_hl(0, 'MatchParen', {
      reverse = true,
      update = true,
    })
    match_parens = true
  end,
})

-- Picker for orgmode saved links
vim.keymap.set('n', '<leader>oll', function()
  -- Retrieve orgmode links and put them in items for the picker
  local stored_links = {}
  for link, desc in pairs(require('orgmode.org.links').stored_links) do
    table.insert(stored_links, {
      text = desc,
      value = string.format('[[%s][%s]]', link, desc),
    })
  end

  -- Open the snacks picker
  Snacks.picker.pick {
    items = stored_links,
    format = 'text',
    layout = 'select',
    confirm = function(picker, choice)
      picker:close()
      if choice then
        -- Insert the text in orgmode format for a link
        vim.api.nvim_put({ choice.value }, 'c', true, true)
      end
    end,
  }
end, { desc = 'List links' })

-- Remember the options for below
local opt_number = vim.wo.number
local opt_relative_number = vim.wo.number

-- Dashboard autocmd
-- This autocmd opens the Org agenda todo-list as a split in the dashboard
-- It only does it once
vim.api.nvim_create_autocmd('User', {
  pattern = 'SnacksDashboardOpened',
  once = true,
  callback = function()
    local dashboard_win = vim.api.nvim_get_current_win()

    -- Count how many TODOs we have.
    local are_there_todos = false
    for _, file in ipairs(require('orgmode.api').load()) do
      for _, headline in ipairs(file.headlines) do
        if headline.todo_type == 'TODO' then
          are_there_todos = true
          goto exit_loops
        end
      end
    end

    ::exit_loops::

    -- Only open if the agenda has todo items at all
    if are_there_todos then
      -- Open org agenda
      vim.cmd 'Org agenda t'

      -- Remove line numbers in this window
      vim.wo.number = false
      vim.wo.relativenumber = false
    end

    vim.schedule(function()
      if vim.api.nvim_win_is_valid(dashboard_win) then
        vim.api.nvim_set_current_win(dashboard_win)
      end
    end)
  end,
})

-- Close orgagenda when closing the dashboard
vim.api.nvim_create_autocmd('User', {
  pattern = 'SnacksDashboardClosed',
  once = true,
  callback = function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local bufnr = vim.api.nvim_win_get_buf(win)

      -- This finds the buffer with a name that contains "orgagenda"
      if vim.api.nvim_buf_get_name(bufnr):match 'orgagenda' then
        vim.api.nvim_win_close(win, true)
      end
    end

    -- Turn line numbers on again
    vim.wo.number = opt_number
    vim.wo.relativenumber = opt_relative_number
  end,
})
