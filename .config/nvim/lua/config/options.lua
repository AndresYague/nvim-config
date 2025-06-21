-- Custom options

vim.opt.colorcolumn = "80"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Change these options for cpp (because of clangd)

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "cpp",
	callback = function()
		vim.opt.tabstop = 2
		vim.opt.shiftwidth = 2
	end,
})
