local parsers = {
  'bash',
  'c',
  'cmake',
  'comment',
  'commonlisp',
  'cpp',
  'css',
  'diff',
  'dockerfile',
  'fish',
  'fortran',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'latex',
  'lua',
  'luadoc',
  'luap',
  'markdown',
  'markdown_inline',
  'printf',
  'python',
  'qmljs',
  'query',
  'regex',
  'scss',
  'svelte',
  'toml',
  'tsx',
  'typescript',
  'typst',
  'vim',
  'vimdoc',
  'vue',
  'xml',
  'yaml',
  'zig',
}
require('nvim-treesitter').install(parsers)

-- Add names of FileType that do not coincide with the name of the parser
table.insert(parsers, 'sh') -- This is the bash filetype.

-- Start the parser in all the above filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = parsers,
  callback = function(args)
    -- args.match contains the filetype
    local language = vim.treesitter.language.get_lang(args.match)
    if not language then
      return
    end

    -- Start treesitter for highlighting and folds
    -- assuming the languages in "parsers" got installed
    vim.treesitter.start(args.buf, language)
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

    -- Add indent if it has it
    if vim.treesitter.query.get(language, 'indents') then
      -- enables treesitter based indentation
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
