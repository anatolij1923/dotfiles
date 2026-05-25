return {
	"uga-rosa/ccc.nvim",
	event = { "BufReadPre" },
	opts = {
		highlighter = {
			auto_enable = true, -- enable highlight automatically
			lsp = true, -- highlight colors from LSP too
		},
		highlight_mode = "bg",
	},
}
