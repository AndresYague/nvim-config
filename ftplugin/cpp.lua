vim.bo.tabstop = 2
vim.bo.shiftwidth = 2

-- Test if make would work
local ret = vim.system({ 'make', '-n' }):wait()

-- If not, try to run this instead
if ret.code ~= 0 then
  if vim.fn.filereadable 'CMakeLists.txt' then
    vim.bo.makeprg = 'cmake --build build -j'
  else
    vim.bo.makeprg = 'gcc -Wall -Wextra -o '
      .. vim.fn.expand '%:r'
      .. ' '
      .. vim.fn.expand '%'
  end
end
