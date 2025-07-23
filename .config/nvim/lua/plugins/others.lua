return {
  {
    'AndresYague/move-enclosing.nvim',
    opts = { word_keymap = '<C-E>', WORD_keymap = '<C-S-E>' },
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
}
