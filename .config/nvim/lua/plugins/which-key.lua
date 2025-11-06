return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      preset = 'helix',
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
        rules = {
          { pattern = 'oil', icon = ' ', color = 'yellow' },
          { pattern = 'harpoon', icon = '󰛢', color = 'orange' },
          { pattern = 'run', icon = ' ', color = 'green' },
          { pattern = 'lazy', icon = '💤 '},
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>b', group = 'Buffer' },
        { '<leader>c', group = 'Code' },
        { '<leader>d', group = 'Debug' },
        { '<leader>f', group = 'Find' },
        { '<leader>g', group = 'Git' },
        { '<leader>h', group = 'Git Hunk' },
        { '<leader>j', group = 'Harpoon' },
        { '<leader>l', group = 'Lazy' },
        { '<leader>q', group = 'Sessions' },
        { '<leader>r', group = 'Run' },
        { '<leader>s', group = 'Search' },
        { '<leader>t', group = 'Terminal' },
        { '<leader>u', group = 'UI' },
        { '<leader>w', group = 'Git worktree' },
      },
    },
  },
}
