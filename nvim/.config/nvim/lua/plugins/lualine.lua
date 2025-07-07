return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		lualine.setup({
			options = {
				-- section_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				component_separators = { left = "|", right = "|" },
			},

            sections = {
                lualine_a = { "mode" },
                lualine_b = { "filename", "branch", "diff" },
                lualine_c = {},
                lualine_x = {},
                lualine_y = { "diagnostics" },
                lualine_z = { "location" },
            },
		})
	end,
}
