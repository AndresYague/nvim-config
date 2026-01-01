return {
  {
    'vhyrro/luarocks.nvim',
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
  {
    'nvim-neorg/neorg',
    dependencies = { 'vhyrro/luarocks.nvim', 'nvim-treesitter/nvim-treesitter' },
    version = '*',
    -- put any other flags you wanted to pass to lazy here!
    opts = {
      function()
        require('neorg').setup {
          load = {
            ['core.defaults'] = {},
            ['core.latex.renderer'] = {
              conceal = true,
              renderer = 'core.integrations.image',
            },
            ['core.concealer'] = {
              config = {
                folds = true,
                icon_preset = 'basic',
              },
            },
            ['core.dirman'] = {
              config = {
                workspaces = {
                  notes = '~/notes',
                },
                default_workspace = 'notes',
              },
            },
          },
        }
      end,
    },
  },
}
