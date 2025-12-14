return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
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
  {
    'ysmb-wtsg/in-and-out.nvim',
    keys = {
      {
        '<C-I>',
        function()
          require('in-and-out').in_and_out()
        end,
        mode = 'i',
      },
    },
  },
}
