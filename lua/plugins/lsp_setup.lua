-- Setup mason early for lsp capabilities below
require('mason').setup()
require('mason-lspconfig').setup()

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    -- Uncomment to enable inlay hints automatically
    -- vim.lsp.inlay_hint.enable()

    -- This ensures that whenever you call hover in an LSP buffer,
    -- it uses rounded borders
    vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover { border = 'rounded' }
    end, { buffer = event.buf })

    -- Create a function that lets us more easily define mappings
    -- specific for LSP related items. It sets the mode, buffer and
    -- description for us each time.
    ---@param keys string
    ---@param func function
    ---@param desc string
    ---@param mode? string|string[]
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(
        mode,
        keys,
        func,
        { buffer = event.buf, desc = 'LSP: ' .. desc }
      )
    end

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('<leader>cr', vim.lsp.buf.rename, 'Rename')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })

    -- Go to references
    map('gr', vim.lsp.buf.references, 'references', { 'n', 'x' })

    -- Go to type definition
    map('gy', vim.lsp.buf.type_definition, 'type definition', { 'n', 'x' })

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    -- See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second
    -- autocommand).
    -- Only do so if the lsp client supports it
    if client.server_capabilities.documentHighlightProvider then
      local highlight_augroup =
        vim.api.nvim_create_augroup('lsp-highlight', { clear = false })

      -- Ignore fugitive files
      local match_str = 'fugitive://'

      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = function()
          if event.file:sub(1, match_str:len()) ~= match_str then
            vim.lsp.buf.document_highlight()
          end
        end,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = function()
          if event.file:sub(1, match_str:len()) ~= match_str then
            vim.lsp.buf.clear_references()
          end
        end,
      })
    end

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
      callback = function(event2)
        -- Only clear references if this path can be accessed
        if vim.uv.fs_stat(event.file) then
          vim.lsp.buf.clear_references()
          pcall(vim.api.nvim_clear_autocmds, {
            group = 'lsp-highlight',
            buffer = event2.buf,
          })
        end
      end,
    })
  end,
})

-- Diagnostic Config
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}

-- Ensure the servers and tools above are installed
-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
local all_tools = {
  'autopep8',
  'bacon-ls',
  'bash-language-server',
  'bibtex-tidy',
  'clang-format',
  'clangd',
  'cmakelang',
  'cmakelint',
  'codelldb',
  'debugpy',
  'findent',
  'fish-lsp',
  'fortitude',
  'fortls',
  'fprettify',
  'gopls',
  'isort',
  'json-lsp',
  'jupytext',
  'local-lua-debugger-vscode',
  'lua-language-server',
  'markdownlint',
  'mypy',
  'neocmake',
  'pydocstyle',
  'python-lsp-server',
  'qmlls',
  'ruff',
  'shellcheck',
  'shfmt',
  'stylua',
  'taplo',
  'tex-fmt',
  'texlab',
  'zls',
}
require('mason-tool-installer').setup {
  ensure_installed = all_tools,
}

-- HACK: Using none-ls (null-ls) to attach the formatter to fortls
require('null-ls').setup {
  sources = {
    -- Hooks up fprettify from Mason as a recognized LSP formatter
    require('null-ls').builtins.formatting.fprettify,
  },
}

-- Only activate the servers. Also, LSPs may have different names
-- in nvim than the tools have in mason, such as lua-language-server -> lua_ls
-- so write those correctly here
local all_servers = {
  'bacon-ls',
  'bashls',
  'clangd',
  'fish_lsp',
  'fortls',
  'gopls',
  'json-lsp',
  'lua_ls',
  'neocmakelsp',
  'pylsp',
  'qmlls',
  'stylua',
  'taplo',
  'texlab',
  'zls',
}

-- Configure every server with the default setup
for _, server in pairs(all_servers) do
  vim.lsp.config(server, {})
end

-- lua_ls configuration with lazydev
require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

-- Enable the servers
-- This calls the configuration in lsp/
vim.lsp.enable(all_servers)

-- Commands related to LSPs

-- Command to install mypy stubs using mason's venv
vim.api.nvim_create_user_command('MypyStubInstall', function(args)
  vim.fn.stdpath 'data'
  local mason_mypy_pip = vim.fn.stdpath 'data'
    .. '/mason/packages/mypy/venv/bin/pip'

  -- Check if pip exists
  if vim.fn.executable(mason_mypy_pip) == 0 then
    vim.notify('Mason mypy not found', vim.log.levels.ERROR)
    return
  end

  local cmd = mason_mypy_pip .. ' install ' .. args.args

  -- Ryn asynchronously with ouput
  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify('Mypy stubs installed successfully', vim.log.levels.INFO)
      else
        vim.notify('Failed to install mypy stubs', vim.log.levels.ERROR)
      end
    end,
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        print(table.concat(data, '\n'))
      end
    end,
  })
end, {
  nargs = '+',
  desc = 'Install mypy stubs using Mason venv',
})
