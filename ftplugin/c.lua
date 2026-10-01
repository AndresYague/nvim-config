vim.bo.tabstop = 2
vim.bo.shiftwidth = 2

-- Test if make would work
local ret = vim.system({ 'make', '-n' }):wait()

-- Sometimes neovim picks this file for cpp plugins, so
-- add here the only difference between c and cpp.
local compiler = vim.bo.ft == 'c' and 'gcc' or 'g++'

-- If not, try to run this instead
if ret.code ~= 0 then
  if vim.fn.filereadable 'CMakeLists.txt' == 1 then
    vim.bo.makeprg = 'cmake --build build -j'
  else
    vim.bo.makeprg = compiler
      .. ' -Wall -Wextra -o '
      .. vim.fn.expand '%:r'
      .. ' '
      .. vim.fn.expand '%'
  end
end
