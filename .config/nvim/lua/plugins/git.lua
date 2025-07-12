return {
  'tpope/vim-fugitive',

  {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    opts = {
      signs_staged_enable = true,
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'overlay', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        -- Setup keymaps
        vim.api.nvim_buf_set_keymap(
          bufnr,
          'n',
          '<leader>hb',
          '<cmd>lua require"gitsigns".blame_line()<CR>',
          { desc = 'Blame Line' }
        )
        vim.api.nvim_buf_set_keymap(
          bufnr,
          'n',
          ']h',
          '<cmd>lua require"gitsigns".next_hunk()<CR>',
          { desc = 'Goto next hunk' }
        )
        vim.api.nvim_buf_set_keymap(
          bufnr,
          'n',
          '[h',
          '<cmd>lua require"gitsigns".prev_hunk()<CR>',
          { desc = 'Goto previous hunk' }
        )
        vim.api.nvim_buf_set_keymap(
          bufnr,
          'n',
          '<leader>hp',
          '<cmd>lua require"gitsigns".preview_hunk_inline()<CR>',
          { desc = 'Preview Hunk inline' }
        )
        vim.api.nvim_buf_set_keymap(
          bufnr,
          'n',
          '<leader>hr',
          '<cmd>lua require"gitsigns".reset_hunk()<CR>',
          { desc = 'Reset Hunk' }
        )
        vim.api.nvim_buf_set_keymap(
          bufnr,
          'n',
          '<leader>hs',
          '<cmd>lua require"gitsigns".stage_hunk()<CR>',
          { desc = 'Stage Hunk' }
        )
        vim.api.nvim_buf_set_keymap(
          bufnr,
          'n',
          '<leader>hu',
          '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
          { desc = 'Undo Stage Hunk' }
        )
      end,
    },
  },
  {
    'AndresYague/git-worktree.nvim',
  },
}
