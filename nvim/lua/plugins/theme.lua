return {
	{
		"kuri-sun/yoda.nvim",
		-- dir = vim.fn.stdpath("config") .. "/lua/yoda.nvim",
		name = "yoda",
		lazy = false,
		priority = 100,
		opts = {
			theme = "dark",
			-- transparent_background = true,
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "yoda",
		},
	},
}
