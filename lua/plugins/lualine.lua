return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
          refresh_time = 16, -- ~60fps
          events = {
            'WinEnter',
            'BufEnter',
            'BufWritePost',
            'SessionLoadPost',
            'FileChangedShellPost',
            'VimResized',
            'Filetype',
            'CursorMoved',
            'CursorMovedI',
            'ModeChanged',
          },
        },
      },
      sections = {
        lualine_a = {
          {
            -- Add X mode to "mode",
            function()
              -- Dictionary with modes
              local mode_names = {
                n = 'NORMAL',
                no = 'O-PENDING',
                nov = 'O-PENDING',
                noV = 'O-PENDING',
                niI = 'I-NORMAL',
                niR = 'R-NORMAL',
                niV = 'V-NORMAL',
                nt = 'NORMAL',
                ntT = 'I-NORMAL',
                v = 'VISUAL',
                vs = 'S-VISUAL',
                V = 'VISUAL',
                Vs = 'S-VISUAL',
                s = 'SELECT',
                S = 'SELECT',
                i = 'INSERT',
                ic = 'I-COMPLETION',
                ix = 'X-MODE',
                R = 'REPLACE',
                Rc = 'R-COMPLETION',
                Rx = 'X-MODE',
                Rv = 'VIRT-REPLACE',
                Rvc = 'VR-COMPLETION',
                Rvx = 'X-MODE',
                c = 'COMMAND',
                cr = 'OVERSTRIKE',
                cv = 'EX',
                cvr = 'EX-OVERSTRIKE',
                r = 'PROMPT',
                rm = 'MORE',
                t = 'TERMINAL',
              }
              -- Add the modes that have special characters
              mode_names['noCTRL-V'] = 'O-PENDING'
              mode_names['CTRL-V'] = 'VISUAL'
              mode_names['CTRL-Vs'] = 'VISUAL'
              mode_names['CTRL-S'] = 'SELECT'
              mode_names['r?'] = 'CONFIRM'
              mode_names['!'] = 'EXTERNAL'
              mode_names['\22'] = 'V-BLOCK'

              -- Retrieve and return mode
              return mode_names[vim.api.nvim_get_mode().mode]
            end,
          },
        },
        lualine_b = {
          -- 'filename', -- TODO: Remove eventually
          'windows',
          { 'lsp_status', icon = '' },
          'diagnostics',
        },
        lualine_c = {
          'branch',
          'diff',
          'searchcount',
          {
            -- Recorder
            function()
              return require('recorder').displaySlots()
                .. require('recorder').recordingStatus()
            end,
          },
          -- NOTE: Uncomment if we want to see "@recording"
          -- {
          --   require('noice').api.status.mode.get,
          --   cond = require('noice').api.status.mode.has,
          --   color = { fg = '#ff9e64' },
          -- },
        },
        lualine_x = {
          '%S', -- This can be used because vim.o.showcmdloc = 'statusline' is in the opts
          'encoding',
          'fileformat',
          'filetype',
        },
        lualine_y = { 'selectioncount', 'progress', 'location' },
        lualine_z = { { 'datetime', style = '%a %d-%m-%y %H:%M' } },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    },
  },
}
