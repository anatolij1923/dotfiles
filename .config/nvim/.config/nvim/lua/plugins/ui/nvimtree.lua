return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "\\", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
	},
	config = function()
		require("nvim-tree").setup({
			disable_netrw = true,
			hijack_cursor = true,
			sync_root_with_cwd = true,

			view = {
				width = 30,
			},
			renderer = {
				icons = {},
			},
		})
	end,
}
