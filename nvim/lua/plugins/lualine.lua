return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "yoda" },
	event = "VeryLazy",
	config = function()
		require("yoda").lualine.setup()
	end,
}
