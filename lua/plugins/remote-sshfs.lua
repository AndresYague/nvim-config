require('remote-sshfs').setup {
  handlers = {
    on_connect = {
      change_dir = true,
    },
  },

  ui = {
    picker = 'snacks',
    confirm = {
      connect = false,
    },
  },

  sshfs_args = {
    '-o',
    'cache=yes',                      -- Enable basic caching
    '-o',
    'kernel_cache',                   -- Cache files directly in system memory
    '-o',
    'compression=no',                 -- Disable CPU-heavy compression over fast networks
    '-o',
    'Ciphers=aes128-gcm@openssh.com', -- Fast, hardware-accelerated cipher
    '-o',
    'auto_cache',                     -- Auto invalidate cache if file modifies on server
    '-o',
    'reconnect',                      -- Seamlessly handle dropouts
  },
}

-- Keymaps

vim.keymap.set(
  'n',
  '<leader>rc',
  require('remote-sshfs.api').connect,
  { desc = 'Remote connect' }
)

vim.keymap.set(
  'n',
  '<leader>rd',
  require('remote-sshfs.api').disconnect,
  { desc = 'Remote disconnect' }
)
