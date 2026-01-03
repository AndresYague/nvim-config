require('which-key').setup {
  -- delay between pressing a key and opening which-key (milliseconds)
  -- this setting is independent of vim.o.timeoutlen
  delay = 0,
  preset = 'helix',
  icons = {
    rules = {
      { pattern = 'change', icon = ' ', color = 'blue' },
      { pattern = 'delete', icon = '󰆴 ', color = 'red' },
      { pattern = 'execute', icon = ' ', color = 'blue' },
      { pattern = 'file', icon = ' ', color = 'white' },
      { pattern = 'go', icon = '󰬫 ', color = 'blue' },
      { pattern = 'mark', icon = '󰍕 ', color = 'blue' },
      { pattern = 'grep', icon = '󱎸 ', color = 'green' },
      { pattern = 'history', icon = ' ', color = 'red' },
      { pattern = 'lua', icon = ' ' },
      { pattern = 'oil', icon = ' ', color = 'yellow' },
      { pattern = 'plugin', icon = ' ', color = 'blue' },
      { pattern = 'remove', icon = ' ', color = 'red' },
      { pattern = 'run', icon = ' ', color = 'orange' },
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
    { '<leader>j', group = 'Mark jumps' },
    { '<leader>p', group = 'Plugin' },
    { '<leader>q', group = 'Sessions' },
    { '<leader>r', group = 'Run' },
    { '<leader>s', group = 'Search' },
    { '<leader>t', group = 'Terminal' },
    { '<leader>u', group = 'UI + Toggles' },
    { '<leader>x', group = 'Execute' },
  },
}
