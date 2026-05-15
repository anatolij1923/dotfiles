return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "echasnovski/mini.nvim" },
	event = "BufReadPre",

	config = function()
		local function location()
			local current_line = vim.fn.line(".")
			local all_lines = vim.fn.line("$")

			return string.format("%s/%s", current_line, all_lines)
		end

		local function lsp()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then
				return "No acitve LSP's"
			end

			local names = {}
			for _, client in ipairs(clients) do
				table.insert(names, client.name)
			end
			local names_str = table.concat(names, ", ")
			return "LSP: " .. names_str
		end

		local function check_macro_recording() end

		require("lualine").setup({

			options = {
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				theme = "auto",
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "starter", "snacks_dashboard" } },
			},

			sections = {
				lualine_a = {
					{ "mode", color = { gui = "bold" } },
				},
				lualine_b = {
					{
						function()
							local name = vim.fn.expand("%:t")
							if name == "" then
								return ""
							end
							local icon, _ = MiniIcons.get("file", name)
							return icon
						end,
						padding = { left = 1, right = 0 },
						color = function()
							local name = vim.fn.expand("%:t")
							local _, hl = MiniIcons.get("file", name)
							local data = vim.api.nvim_get_hl(0, { name = hl, link = false })
							return data and data.fg and { fg = string.format("#%06x", data.fg) } or nil
						end,
					},
					{
						"filename",
						path = 1,
						-- symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
						padding = { left = 1, right = 1 },
					},
				},
				lualine_c = {
					{ "branch", icon = "" },
					{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
					-- {
					-- 	require("noice").api.statusline.mode.get,
					-- 	cond = require("noice").api.statusline.mode.has,
					-- 	color = { fg = "#ff9e64" },
					-- },
				},
				lualine_x = {},
				lualine_y = {
					{ "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
					{ lsp },
				},
				lualine_z = {
					{ location, color = { gui = "bold" } },
				},
			},
		})
		vim.api.nvim_create_autocmd("RecordingEnter", {
			callback = function()
				require("lualine").refresh()
			end,
		})
		vim.api.nvim_create_autocmd("RecordingLeave", {
			callback = function()
				vim.defer_fn(function()
					require("lualine").refresh()
				end, 50)
			end,
		})
	end,
}
