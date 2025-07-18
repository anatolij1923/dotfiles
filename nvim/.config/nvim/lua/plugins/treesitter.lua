return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",

		config = function()
			local treesitter = require("nvim-treesitter.configs")

			-- configuring treesitter
			treesitter.setup({
				highlight = {
					enable = true,
				},

				indent = {
					enable = true,
				},

				ensure_installed = {
					"json",
					"javascript",
					"typescript",
					"tsx",
					"go",
					"yaml",
					"html",
					"css",
					"python",
					"http",
					"prisma",
					"markdown",
					"markdown_inline",
					"svelte",
					"graphql",
					"bash",
					"lua",
					"vim",
					"dockerfile",
					"gitignore",
					"query",
					"vimdoc",
					"c",
					"java",
					"rust",
				},

				incremental_selection = {
					enabled = true,
					keymaps = {
						init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        node_decremental = "<BS>",
						-- node_selection = "<C-space>",
						scope_incremental = false,
					},
				},


				additional_vim_regex_highlighting = false,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
		config = function()
			-- Independent nvim-ts-autotag setup
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true, -- Auto-close tags
					enable_rename = true, -- Auto-rename pairs
					enable_close_on_slash = false, -- Disable auto-close on trailing `</`
				},
				per_filetype = {
					["html"] = {
						enable_close = true, -- Disable auto-closing for HTML
					},
					["typescriptreact"] = {
						enable_close = true, -- Explicitly enable auto-closing (optional, defaults to `true`)
					},
				},
			})
		end,
	},
}
