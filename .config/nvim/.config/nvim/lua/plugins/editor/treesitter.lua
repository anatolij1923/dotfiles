return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			ts.setup({})

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("ts_smart_install", { clear = true }),
				callback = function(event)
					local buf = event.buf

					if vim.bo[buf].buftype ~= "" then
						return
					end

					local ft = vim.bo[buf].filetype
					if ft == "" or ft == "gitcommit" then
						return
					end

					local lang = vim.treesitter.language.get_lang(ft) or ft

					local function enable_ts()
						if not vim.api.nvim_buf_is_valid(buf) then
							return
						end

						pcall(vim.treesitter.start, buf, lang)

						local has_indents = #vim.api.nvim_get_runtime_file(
								"queries/" .. lang .. "/indents.scm",
								false
							) > 0

						if has_indents then
							vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
							vim.bo[buf].smartindent = false
						else
							vim.bo[buf].indentexpr = ""
							vim.bo[buf].smartindent = true
							vim.bo[buf].autoindent = true
						end

						vim.wo.foldmethod = "expr"
						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					end

					local installed = ts.get_installed()
					local is_installed = vim.tbl_contains(installed, lang)

					if not is_installed then
						local available = ts.get_available()
						if vim.tbl_contains(available, lang) then
							vim.notify("Treesitter: installing parser for " .. lang)
							local res = ts.install(lang)
							if res then
								res:wait(5000)
								vim.schedule(enable_ts)
							end
						end
					else
						enable_ts()
					end
				end,
			})
		end,
	},
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					node_incremental = "<CR>",
					node_decremental = "<BS>",
					scope_incremental = "<S-CR>",
				},
			},
		},
	},
}
