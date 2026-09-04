require('vim._core.ui2').enable()

-- Configure the extra options in messagesopt
if vim.fn.has 'nvim-0.13.0' == 1 then
  vim.o.messagesopt = vim.o.messagesopt
    .. ',maxheight:50,pager:<CR>,timeout:4000'
end
