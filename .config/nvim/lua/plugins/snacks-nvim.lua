local Snacks = require 'snacks'
local devicons = require 'nvim-web-devicons'

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
          key = 'g',
          desc = 'Find Text',
          action = ":lua Snacks.dashboard.pick('live_grep')",
        },
        {
          icon = ' ',
          key = 'o',
          desc = 'Oil',
          action = ':Oil',
        },
        {
          icon = ' ',
          key = 's',
          desc = 'Restore Session',
          action = ":lua require('persistence').load()",
        },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
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
        enabled = true,
        'arguments',
        'case_statement',
        'catch_clause',
        'class_declaration',
        'class_definition',
        'class_specifier',
        'comment',
        'do_statement',
        'enum_specifier',
        'for_range_loop',
        'for_statement',
        'function_declaration',
        'function_definition',
        'gnu_asm_expression',
        'if_statement',
        'initializer_list',
        'lambda_expression',
        'method_declaration',
        'method_definition',
        'namespace_definition',
        'parameters',
        'preproc_elif',
        'preproc_else',
        'preproc_function_def',
        'preproc_if',
        'preproc_ifdef',
        'preproc_include',
        'repeat_statement',
        'struct_specifier',
        'switch_statement',
        'table_constructor',
        'template_declaration',
        'try_statement',
        'while_statement',
      },
      -- these treesitter fields will be considered as blocks
      field_blocks = {
        'local_declaration',
      },
    },
  },

  -- Lazygit
  lazygit = { enabled = true },
  -- Better notifications
  notifier = { enabled = true },
  -- Scratch space
  scratch = { enabled = true },
  -- Smooth scrolling
  scroll = { enabled = true },
  -- Status column on its own
  statuscolumn = { enabled = true },
  -- Toggle things
  toggle = { enabled = true },
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
            ---@diagnostic disable-next-line: missing-fields
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

local visual_bold = false

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
    Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
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
        :map '<leader>uR'
    Snacks.toggle
        .option('cursorcolumn', { name = 'Cursor Column' })
        :map '<leader>ur'

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
        :map '<leader>up'

    -- Toggle Markview
    Snacks.toggle
        .new({
          id = 'markview',
          name = 'Markview',
          get = function()
            local buffer = vim.api.nvim_get_current_buf()
            if not require('markview.state').buf_attached(buffer) then
              require('markview.commands').attach(buffer)
              require('markview.commands').disable(buffer)
            end
            return require('markview.state').get_buffer_state(buffer, false).enable
          end,
          set = function()
            local buffer = vim.api.nvim_get_current_buf()
            require('markview.commands').toggle(buffer)
          end,
        })
        :map '<leader>um'

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

    -- Fully custom toggle for visual_bold
    Snacks.toggle
        .new({
          id = 'visual_bold',
          name = 'Visual Bold',
          get = function()
            return visual_bold
          end,
          set = function(state)
            if state then
              vim.cmd.highlight {
                args = { 'link Visual IncSearch' },
                bang = true,
              }
              visual_bold = true
            else
              vim.cmd.highlight { args = { 'link Visual NONE' } }
              visual_bold = false
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
vim.keymap.set('n', '<leader>.', function()
  Snacks.scratch()
end, { desc = 'Toggle Scratch Buffer' })
vim.keymap.set('n', '<leader>S', function()
  Snacks.scratch.select()
end, { desc = 'Select Scratch Buffer' })
vim.keymap.set('n', '<leader>n', function()
  Snacks.notifier.show_history()
end, { desc = 'Notification History' })
vim.keymap.set('n', '<leader>cR', function()
  Snacks.rename.rename_file()
end, { desc = 'Rename File' })
vim.keymap.set({ 'n', 'v' }, '<leader>gB', function()
  Snacks.gitbrowse()
end, { desc = 'Git Browse' })
vim.keymap.set('n', '<leader>gg', function()
  Snacks.lazygit()
end, { desc = 'Lazygit' })
vim.keymap.set('n', '<leader>un', function()
  Snacks.notifier.hide()
end, { desc = 'Dismiss All Notifications' })
