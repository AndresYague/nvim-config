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
    'AndresYague/nvim-colorizer.lua',
    config = function()
      -- Attaches to every FileType mode
      require('colorizer').setup({ '*' }, {
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        mode = 'background',
      })
    end,
  },
}
