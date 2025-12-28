require('neorg').setup {
  load = {
    ['core.defaults'] = {},
    ['core.latex.renderer'] = {
      config = {
        conceal = true,
        renderer = 'core.integrations.image',
      },
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
