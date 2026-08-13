local tt = require 'time-tracker'

vim.keymap.set('n', '<leader>ki', function()
  tt.start_clock()
end, { desc = 'Clock in' })

vim.keymap.set('n', '<leader>ko', function()
  tt.stop_clock(true)
end, { desc = 'Clock out' })

vim.keymap.set('n', '<leader>kl', function()
  tt.notify_clock()
end, { desc = 'List clocks' })

vim.keymap.set('n', '<leader>kj', function()
  tt.adjust_clock()
end, { desc = 'Adjust clocks' })

vim.keymap.set('n', '<leader>kt', function()
  tt.notify_elapsed_time()
end, { desc = 'Total time elapsed' })

vim.keymap.set('n', '<leader>kr', function()
  tt.clear_clocks()
end, { desc = 'Reset clocks' })

vim.keymap.set('n', '<leader>ka', function()
  tt.add_clock()
end, { desc = 'Add clock' })

vim.keymap.set('n', '<leader>kd', function()
  tt.remove_clock()
end, { desc = 'Delete clock' })
