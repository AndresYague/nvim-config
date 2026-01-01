return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    -- TODO:
    -- Pin to version that works with textobjects and neorg, this version
    -- uses "nvim-treesitter.configs" instead of "nvim-treesitter.config"
    version = '0.10.0',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        modules = {},
        ensure_installed = {
          'bash',
          'c',
          'comment',
          'cpp',
          'css',
          'diff',
          'fish',
          'fortran',
          'html',
          'javascript',
          'jsdoc',
          'json',
          'jsonc',
          'latex',
          'lua',
          'luadoc',
          'luap',
          'markdown',
          'markdown_inline',
          'norg',
          'printf',
          'python',
          'query',
          'regex',
          'scss',
          'svelte',
          'toml',
          'tsx',
          'typescript',
          'typst',
          'vim',
          'vimdoc',
          'vue',
          'xml',
          'yaml',
        },

        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true },
        sync_install = true,
        ignore_install = {},
        indent = { enable = true },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      separator = '=',
      max_lines = '30%',
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    -- enabled = false,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '+',
            scope_incremental = '<CR>',
            node_incremental = '<TAB>',
            node_decremental = '<S-TAB>',
          },
        },

        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']f'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']F'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[F'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },

          swap = {
            enable = true,
            swap_next = {
              ['<leader>cs'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>cS'] = '@parameter.inner',
            },
          },

          select = {
            enable = true,

            -- Automatically jump forward to textobjects, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['af'] = { query = '@function.outer', desc = 'Around a function' },
              ['if'] = { query = '@function.inner', desc = 'Inside a function' },
              ['ac'] = { query = '@class.outer', desc = 'Around a class' },
              ['ic'] = { query = '@class.inner', desc = 'Inside class' },
            },
            -- You can choose the select mode (default is charwise 'v')
            -- selection_modes = {
            --   ['@parameter.outer'] = 'v', -- charwise
            --   ['@function.outer'] = 'V', -- linewise
            --   ['@class.outer'] = '<c-v>', -- blockwise
            -- },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`. Can also be a function (see above).
            include_surrounding_whitespace = false,
          },
        },
      }
    end,
  },
}
