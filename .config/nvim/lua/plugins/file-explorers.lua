return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    lazy = false,
    keys = {
      {
        '<leader>e',
        ':Neotree reveal<CR>',
        desc = 'NeoTree reveal',
        silent = true,
      },
    },
    opts = {
      filesystem = {
        window = {
          mappings = {
            ['<leader>e'] = 'close_window',
          },
        },
      },
    },
  },
  {
    'stevearc/oil.nvim',
    opts = {
      skip_confirm_for_simple_edits = true,
      watch_for_changes = true,
      use_default_keymaps = false,
      keymaps = {
        ["-"] = { "actions.cd", mode = "n" },
        ["<BS>"] = { "actions.parent", mode = "n" },
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-p>"] = "actions.preview",
        ["<CR>"] = "actions.select",
        ["<leader>h"] = { "actions.select", opts = { horizontal = true } },
        ["<leader>v"] = { "actions.select", opts = { vertical = true } },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
      }
    },
  },
}
