-- Configure lua_ls
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.git', 'stylua.toml', '.stylua.toml', '.luarc.json' },

  settings = {
    Lua = {
      -- Stop native lua_ls formatting
      format = {
        enable = false,
      },
      -- Ignore the vim global error
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
}
