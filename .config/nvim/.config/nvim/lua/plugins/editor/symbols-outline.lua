return {
	"simrat39/symbols-outline.nvim",
	cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
	keys = {
		{ "<leader>o", "<cmd>SymbolsOutline<cr>", desc = "Toggle Outline" },
	},
	config = function()
		require("symbols-outline").setup({
			highlight_hovered_item = true,
			show_guides = true,
			auto_preview = false,
			position = "right", -- можно left
			width = 25,
			symbols = {},
		})
	end,
}
