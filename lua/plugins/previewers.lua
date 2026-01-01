-- For `plugins/markview.lua` users.
return {
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    ft = { 'markdown', 'yaml', 'tex' },
    opts = {
      preview = {
        enable = true,
        icon_provider = 'devicons',
      },
      yaml = {
        enable = true,
      },
    },

    -- Dependencies
    dependencies = { 'saghen/blink.cmp', 'nvim-treesitter/nvim-treesitter' },
  },
}
