return {
	"echasnovski/mini.nvim",
	event = "VeryLazy",
	version = false,
	keys = {
		{
			"-",
			function()
				if not MiniFiles.close() then
					MiniFiles.open(vim.api.nvim_buf_get_name(0))
				end
			end,
			desc = "Open mini.files",
		},
	},
	config = function()
		require("mini.files").setup({
			windows = {
				preview = true,
				width_focus = 35,
				width_preview = 50,
				options = { use_as_default_explorer = true, lsp_timeout = 0 },
			},
		})

		local mini_icons = require("mini.icons")
		mini_icons.setup()
		mini_icons.mock_nvim_web_devicons()

		require("mini.pairs").setup({})

		require("mini.tabline").setup({})

		require("mini.surround").setup({
			mappings = {
				add = "gsa",
				delete = "gsd",
				replace = "gsr",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				update_n_lines = "gsn",
			},
		})
		require("mini.ai").setup({
			mappings = {
				inside_next = "gin",
				around_next = "gan",
				around_last = "gal",
				inside_last = "gil",
			},
		})

		require("mini.bracketed").setup({})
	end,
}
