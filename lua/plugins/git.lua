require('gitsigns').setup {
  signs = {
    add = { text = '|' },
  },
  signs_staged = {
    add = { text = '|' },
  },
  signs_staged_enable = true,
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = true,      -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
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
  status_formatter = nil,  -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },
  -- NOTE: Not needed bufnr here as keyamp applies to current buffer
  on_attach = function( --[[ bufnr ]])
    -- Setup keymaps
    vim.keymap.set('n', '<leader>hb', function()
      require('gitsigns').blame_line()
    end, { desc = 'Blame Line' })
    vim.keymap.set('n', ']h', function()
      require('gitsigns').nav_hunk 'next'
    end, { desc = 'Goto next hunk' })
    vim.keymap.set('n', '[h', function()
      require('gitsigns').nav_hunk 'prev'
    end, { desc = 'Goto previous hunk' })
    vim.keymap.set('n', '<leader>hp', function()
      require('gitsigns').preview_hunk_inline()
    end, { desc = 'Preview Hunk inline' })
    vim.keymap.set('n', '<leader>hr', function()
      require('gitsigns').reset_hunk()
    end, { desc = 'Reset Hunk' })
    vim.keymap.set('n', '<leader>hs', function()
      require('gitsigns').stage_hunk()
    end, { desc = 'Stage/Unstage Hunk' })
  end,
}
