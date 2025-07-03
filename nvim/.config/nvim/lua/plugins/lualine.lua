return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		lualine.setup({
			-- options = {
			-- 	section_separators = { left = "", right = "" },
			-- },
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "filename", "branch", "diagnostics", "diff"},
				lualine_c = {},
				lualine_x = {"filetype"},
				lualine_y = {"progress"},
				lualine_z = {"location"},
			},
		})
	end,
}
