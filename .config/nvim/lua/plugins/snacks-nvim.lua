local Snacks = require 'snacks'
local devicons = require 'nvim-web-devicons'

Snacks.setup {
  bigfile = { enabled = true }, -- Deactivates things for files too large
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
          icon = ' ',
          key = 'n',
          desc = 'New File',
          action = ':ene | startinsert',
        },
        {
          icon = ' ',
          key = 'g',
          desc = 'Find Text',
          action = ":lua Snacks.dashboard.pick('live_grep')",
        },
        {
          icon = ' ',
          key = 'r',
          desc = 'Recent Files',
          action = ":lua Snacks.dashboard.pick('oldfiles')",
        },
        {
          icon = ' ',
          key = 'c',
          desc = 'Config',
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        {
          icon = ' ',
          key = 's',
          desc = 'Restore Session',
          action = '<leader>qs',
        },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
    },
  }, -- Initial neovim dashboard
  explorer = { enabled = true }, -- File explorer
  image = { enabled = true }, -- Render images
  indent = { enabled = true, chunk = { enabled = true } }, -- Indent lines
  quickfile = { enabled = true }, -- Load file as fast as possible
  rename = { enabled = true }, -- Rename files
  scope = {
    enabled = true,
    treesitter = {
      blocks = {
        enabled = true,
        'class_declaration',
        'class_definition',
        'do_statement',
        'for_range_loop',
        'for_statement',
        'function_declaration',
        'function_definition',
        'if_statement',
        'method_declaration',
        'method_definition',
        'repeat_statement',
        'while_statement',
      },
      -- these treesitter fields will be considered as blocks
      field_blocks = {
        'local_declaration',
      },
    },
  }, -- Scope jumps
  lazygit = { enabled = true }, -- Lazygit
  notifier = { enabled = true }, -- Better notifications
  scratch = { enabled = true }, -- Scratch space
  scroll = { enabled = true }, -- Smooth scrolling
  statuscolumn = { enabled = true }, -- Status column on its own
  toggle = { enabled = true }, -- Toggle things
  words = { enabled = true }, -- LSP help for references
  zen = { enabled = true }, -- Zen/Zoom mode
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
              return true
            end

            -- If the choice is all, handle it properly
            if choice == 'all' then
              picker.opts.prompt = ' '
              picker.opts.ft = {}
            else
              local icon = devicons.get_icon_by_filetype(choice, {})

              if icon then
                picker.opts.prompt = icon .. '  '
              else
                picker.opts.prompt = choice .. ' '
              end
              picker.opts.ft = choice
            end
          end
        )
      end,
    },
  },
  keys = {
    {
      '<C-w>z',
      function()
        Snacks.zen()
      end,
      desc = 'Toggle Zen Mode',
    },
    {
      '<C-w>m',
      function()
        Snacks.zen.zoom()
      end,
      desc = 'Toggle Zoom',
    },
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
    {
      '<leader>n',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    {
      '<leader>cR',
      function()
        Snacks.rename.rename_file()
      end,
      desc = 'Rename File',
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
      mode = { 'n', 'v' },
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>un',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
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
