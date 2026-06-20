require('lualine').setup {
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
      'windows',
      { 'lsp_status', icon = '' },
      'diagnostics',
    },
    lualine_c = {
      'branch',
      'diff',
      'searchcount',
      function()
        -- Show the current total clocktime in orgmode
        return require('orgmode').statusline_debounced()
      end,
      function()
        -- Go into each letter register and figure out if it has anything in it
        -- if it does, then save it into "records", which will be displayed in
        -- the lualine
        local records = ''

        -- This trick makes a loop over every letter of the alphabet mapping
        -- the anonymous function to it.
        -- Adapted from https://stackoverflow.com/a/832414
        ('abcdefghijklmnopqrstuvwxyz'):gsub('.', function(letter)
          if vim.fn.getreg(letter):len() > 0 then
            records = records .. letter
          end
        end)

        -- Only add the @ symbol if at least one register is not empty
        if records:len() > 0 then
          records = '@' .. records
        end

        return records
      end,
    },
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype',
    },
    lualine_y = { 'selectioncount', 'progress', 'location' },
    lualine_z = { { 'datetime', style = '%a %d-%m-%y %H:%M' } },
  },
  inactive_sections = {},
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {
    'fugitive',
    'oil',
    'quickfix',
    'mason',
  },
}
