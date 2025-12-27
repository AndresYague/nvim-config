local harpoon = require 'harpoon'

harpoon:setup()

vim.keymap.set('n', '<leader>ja', function()
  harpoon:list():add()
end, { desc = 'Add to list' })
vim.keymap.set('n', '<leader>jq', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Harpoon quick menu' })

vim.keymap.set('n', '<leader>j1', function()
  harpoon:list():select(1)
end, { desc = 'Select 1' })
vim.keymap.set('n', '<leader>j2', function()
  harpoon:list():select(2)
end, { desc = 'Select 2' })
vim.keymap.set('n', '<leader>j3', function()
  harpoon:list():select(3)
end, { desc = 'Select 3' })
vim.keymap.set('n', '<leader>j4', function()
  harpoon:list():select(4)
end, { desc = 'Select 4' })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set('n', '<leader>jp', function()
  harpoon:list():prev()
end, { desc = 'Previous' })
vim.keymap.set('n', '<leader>jn', function()
  harpoon:list():next()
end, { desc = 'Next' })
