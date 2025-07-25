return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`

        defaults = {
          mappings = {
            i = {
              ['<C-K>'] = require('telescope.actions.generate').which_key {},
              ['<C-Q>'] = require('telescope.actions').smart_send_to_qflist,
            },
            n = {
              ['<C-Q>'] = require('telescope.actions').smart_send_to_qflist,
            },
          },
        },

        pickers = {
          find_files = {
            theme = 'ivy',
          },
          live_grep = {
            theme = 'ivy',
          },
          colorscheme = {
            enable_preview = true,
          },
        },
        extensions = {
          fzf = {},
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      local utils = require 'telescope.utils'
      vim.keymap.set(
        'n',
        '<leader>sh',
        builtin.help_tags,
        { desc = 'Search Help' }
      )
      vim.keymap.set(
        'n',
        '<leader>sk',
        builtin.keymaps,
        { desc = 'Search Keymaps' }
      )
      vim.keymap.set(
        'n',
        '<C-f>',
        builtin.find_files,
        { desc = 'Search Files' }
      )

      -- Define the function so we can call it recursively
      local attach_find_files

      -- Function to toggle hidden and ignored
      ---@param hidden boolean
      ---@param no_ignore boolean
      ---@param cwd string?
      attach_find_files = function(hidden, no_ignore, cwd)
        -- Show the prefix for hidden and ignored files
        local find_files_prompt_prefix = function()
          local s = ''
          if hidden and no_ignore then
            s = '(h|i)'
          elseif hidden then
            s = '(h)'
          elseif no_ignore then
            s = '(i)'
          end
          return s .. '> '
        end
        local prompt_prefix = find_files_prompt_prefix()

        local prompt_title =
          'Find Files - <C-h> Toogle Hidden - <C-i> Toggle ignore | '
        if cwd then
          prompt_title = prompt_title .. cwd
        else
          prompt_title = prompt_title .. '(Root)'
        end

        builtin.find_files {
          hidden = hidden,
          no_ignore = no_ignore,
          prompt_title = prompt_title,
          prompt_prefix = prompt_prefix,
          cwd = cwd,
          attach_mappings = function(_, map)
            map({ 'i', 'n' }, '<C-h>', function()
              attach_find_files(not hidden, no_ignore, cwd)
            end, { desc = 'Toggle hidden' })
            map({ 'i', 'n' }, '<C-i>', function()
              attach_find_files(hidden, not no_ignore, cwd)
            end, { desc = 'Toggle ignored' })

            -- needs to return true if you want to map default_mappings and
            -- false if not
            return true
          end,
        }
      end

      vim.keymap.set('n', '<C-f>', function()
        attach_find_files(false, false)
      end, { desc = 'Search Files in the root directory' })

      vim.keymap.set('n', '<leader>sf', function()
        attach_find_files(false, false)
      end, { desc = 'Search Files in the root directory' })

      vim.keymap.set('n', '<leader>sF', function()
        attach_find_files(false, false, utils.buffer_dir())
      end, { desc = 'Search files in the current buffer directory' })

      -- Define the function so we can call it recursively
      local attach_live_grep

      -- Function to toggle hidden and filter types
      ---@param hidden boolean
      ---@param type_filter string?
      ---@param cwd string?
      attach_live_grep = function(hidden, type_filter, cwd)
        -- If filter is empty, make it nil
        if type_filter == '' then
          type_filter = nil
        end

        -- Show the prefix for hidden files and type filter
        local live_grep_prompt_prefix = function()
          local s = ''
          if hidden and type_filter then
            s = '(h|' .. type_filter .. ')'
          elseif hidden then
            s = '(h)'
          elseif type_filter then
            s = '(' .. type_filter .. ')'
          end
          return s .. '> '
        end
        local prompt_prefix = live_grep_prompt_prefix()

        -- Set-up the prompt title
        local prompt_title =
          'Live Grep - <C-h> Toogle Hidden - <C-f> Type filter | '
        if cwd then
          prompt_title = prompt_title .. cwd
        else
          prompt_title = prompt_title .. '(Root)'
        end

        local additional_args = {}
        if hidden then
          table.insert(additional_args, '--hidden')
        end

        builtin.live_grep {
          additional_args = additional_args,
          cwd = cwd,
          type_filter = type_filter,
          prompt_title = prompt_title,
          prompt_prefix = prompt_prefix,
          attach_mappings = function(_, map)
            map({ 'i', 'n' }, '<C-h>', function()
              attach_live_grep(not hidden, type_filter, cwd)
            end, { desc = 'Toggle hidden' })
            map({ 'i', 'n' }, '<C-f>', function()
              vim.ui.input({ prompt = 'Filter pattern: ' }, function(input)
                attach_live_grep(hidden, input, cwd)
              end)
            end, { desc = 'Filter by pattern' })

            -- needs to return true if you want to map default_mappings and
            -- false if not
            return true
          end,
        }
      end

      vim.keymap.set('n', '<C-s>', function()
        attach_live_grep(false)
      end, { desc = 'Search by Grep' })

      vim.keymap.set('n', '<leader>sg', function()
        attach_live_grep(false)
      end, { desc = 'Search by Grep' })

      vim.keymap.set('n', '<leader>sG', function()
        attach_live_grep(false, nil, utils.buffer_dir())
      end, { desc = 'Search by Grep in the current buffer directory' })

      vim.keymap.set(
        'n',
        '<leader>ss',
        builtin.builtin,
        { desc = 'Search Select Telescope' }
      )
      vim.keymap.set(
        'n',
        '<leader>sw',
        builtin.grep_string,
        { desc = 'Search current Word' }
      )
      vim.keymap.set(
        'n',
        '<leader>sd',
        builtin.diagnostics,
        { desc = 'Search Diagnostics' }
      )
      vim.keymap.set(
        'n',
        '<leader>sr',
        builtin.resume,
        { desc = 'Search Resume' }
      )
      vim.keymap.set(
        'n',
        '<leader>s.',
        builtin.oldfiles,
        { desc = 'Search Recent Files ("." for repeat)' }
      )
      vim.keymap.set(
        'n',
        '<leader><leader>',
        builtin.buffers,
        { desc = 'Find existing buffers' }
      )

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(
          require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          }
        )
      end, { desc = 'Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = 'Search / in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Search Neovim files' })
    end,
  },
}
