-- Configure pylsp
return {
  cmd = { 'python-lsp-server' },
  filetypes = { 'python' },
  root_markers = { '.git', 'pyproject.toml', '.pyproject.toml' },

  settings = {
    pylsp = {
      plugins = {
        flake8 = {
          enabled = false,
        },
        mypy = {
          enabled = true,
        },
        isort = {
          enabled = true,
        },
        ruff = {
          enabled = true,
        },
        pydocstyle = {
          enabled = true,
        },
      },
    },
  },
}
