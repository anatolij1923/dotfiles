return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-mini/mini.nvim" },
		config = function()
			require("bufferline").setup({})
		end,
	},
}
