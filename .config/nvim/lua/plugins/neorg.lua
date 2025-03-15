return {
	{
		"nvim-neorg/neorg",
		dependencies = { "luarocks.nvim" },
		-- version = "v7.0.0",
		version = "*",
		-- put any other flags you wanted to pass to lazy here!
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {
						config = {
							folds = true,
							icon_preset = "basic",
						},
					},
					["core.dirman"] = {
						config = {
							workspaces = {
								notes = "~/notes",
							},
							default_workspace = "notes",
						},
					},
				},
			})
		end,
	},
}
