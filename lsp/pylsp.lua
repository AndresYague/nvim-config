-- Configure pylsp
return {
  settings = {
    pylsp = {
      plugins = {
        flake8 = {
          enabled = true,
        },
        mypy = {
          enabled = true,
        },
        isort = {
          enabled = true,
        },
        pydocstyle = {
          enabled = true,
        },
      },
    },
  },
}
