return {
	"utilyre/barbecue.nvim",
	name = "barbecue",
	event = "VeryLazy",
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-mini/mini.nvim",
	},
	opts = {
		-- Icons are handled via mini.icons mock
		attach_navic = true,
		show_modified = true,
		exclude_filetypes = { "gitcommit", "Trouble", "toggleterm", "starter" },
	},
}
