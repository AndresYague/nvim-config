return {
  {
    'AndresYague/move-enclosing.nvim',
    opts = { word_keymap = '<C-E>', WORD_keymap = '<C-S-E>' },
  },
  {
    'AndresYague/print-debug.nvim',
    opts = {
      mark = '"',
      keymap = '<leader>dp',
    },
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
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      separator = '-',
    },
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = { numbers = 'none' },
    },
  },
  {
    '3rd/time-tracker.nvim',
    dependencies = {
      '3rd/sqlite.nvim',
    },
    event = 'VeryLazy',
    opts = {
      data_file = vim.fn.stdpath 'data' .. '/time-tracker.db',
    },
  },
}
