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
            function()
              -- Retrieve the mode from nvim_get_mode
              local mode = vim.api.nvim_get_mode().mode
              local mode_map = {
                ['\22'] = 'V-BLOCK',
                c = 'COMMAND',
                i = 'INSERT',
                n = 'NORMAL',
                no = 'O-PENDING',
                nt = 'NORMAL',
                R = 'REPLACE',
                ['^S'] = 'S-BLOCK',
                s = 'SELECT',
                S = 'S-LINE',
                t = 'TERMINAL',
                v = 'VISUAL',
                V = 'V-LINE',
              }

              -- Save the status mode
              local status = mode_map[mode] or mode:upper()

              local reg = vim.fn.reg_recording()
              -- If a macro is being recorded, append "@<register>"
              if reg ~= '' then
                status = status .. ' (Recording @' .. reg .. ')'
              end

              return status
            end,
          },
        },
        lualine_b = {
          'branch',
          'diff',
          { 'lsp_status', icon = '' },
          'diagnostics',
        },
        lualine_c = {
          'filename',
          'searchcount',
        },
        lualine_x = {
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
