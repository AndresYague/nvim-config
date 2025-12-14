-- For `plugins/markview.lua` users.
return {
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    ft = { 'markdown', 'yaml', 'tex' },
    opts = {
      preview = {
        enable = true,
        icon_provider = 'devicons',
      },
      yaml = {
        enable = true,
      },
    },

    -- Dependencies
    dependencies = { 'saghen/blink.cmp', 'nvim-treesitter/nvim-treesitter' },
  },
  {
    '3rd/image.nvim',
    opts = {
      backend = 'kitty', -- or "ueberzug" or "sixel"
      processor = 'magick_cli', -- or "magick_rock"
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          only_render_image_at_cursor_mode = 'popup', -- or "inline"
          floating_windows = false, -- if true, images will be rendered in floating markdown windows
          filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
          enabled = true,
          filetypes = { 'norg' },
        },
        typst = {
          enabled = true,
          filetypes = { 'typst' },
        },
        html = {
          enabled = true,
        },
        css = {
          enabled = true,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      scale_factor = 1.0,
      window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = {
        'cmp_menu',
        'cmp_docs',
        'snacks_notif',
        'scrollview',
        'scrollview_sign',
      },
      editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      hijack_file_patterns = {
        '*.png',
        '*.jpg',
        '*.jpeg',
        '*.gif',
        '*.webp',
        '*.avif',
      }, -- render image files as images when opened
    },
  },

  -- This is needed for nabla.vim
  {
    'williamboman/mason.nvim',
    opts = { ensure_installed = { 'tree-sitter-cli' } },
  },
  {
    'jbyuki/nabla.nvim',
    dependencies = {
      'nvim-neo-tree/neo-tree.nvim',
      'williamboman/mason.nvim',
    },
    lazy = true,

    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'latex' },
        auto_install = true,
        sync_install = false,
      }
    end,
  },
}
