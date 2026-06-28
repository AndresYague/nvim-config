require('codecompanion').setup {
  interactions = {
    chat = {
      adapter = {
        name = 'ollama',
        model = 'qwen2.5-coder:14b',
      },
      inline = {
        enabled = false,
      },
    },
  },

  adapters = {
    http = {
      ollama = function()
        return require('codecompanion.adapters').extend('ollama', {
          env = {
            url = os.getenv 'CODECOMPANION_URL' or 'http://localhost:11434',
          },

          opts = {
            stream = true,
          },

          schema = {
            num_ctx = {
              default = 16384,
            },
          },
          keep_alive = {
            default = '10m',
          },
        })
      end,
    },
  },

  opts = {
    send_code = true,
    tools = false,
  },

  display = {
    chat = {
      window = {
        position = 'left',
        width = 0.4,
      },
    },
  },
}

-- Keymap to open chatbot in visual mode
vim.keymap.set('v', '<leader>cb', function()
  require('codecompanion').chat { mode = 'visual' }
end, { desc = 'Open chatbot (visual)' })

-- Keymap to open chatbot in normal mode
vim.keymap.set('n', '<leader>cb', function()
  -- Make sure that buffer type is not empty
  if vim.bo.buftype ~= '' then
    return
  end
  require('codecompanion').chat()
end, { desc = 'Open chatbot' })
