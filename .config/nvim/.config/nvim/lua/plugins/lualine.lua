return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local devicons = require("nvim-web-devicons")

		local function curr_dir()
			local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
			return "  " .. dir_name
		end

		local function file_with_icon()
			local filename = vim.fn.expand("%:t")
			local extension = vim.fn.expand("%:e")
			local icon, icon_color = devicons.get_icon_color(filename, extension, { default = true })

			if filename == "" then
				filename = "[No Name]"
				icon = ""
				icon_color = "#aaaaaa"
			end

			local status = ""
			if vim.bo.modified then
				status = " ●"
			elseif vim.bo.readonly then
				status = " "
			end

			return icon .. " " .. filename .. status, { fg = icon_color }
		end

		local function lsp_name()
			local msg = "No active LSP"
			local clients = vim.lsp.get_clients({ bufnr = 0 })

			if #clients == 0 then
				return msg
			end

			local client_names = {}

			for _, client in ipairs(clients) do
				table.insert(client_names, client.name)
			end

			if #client_names == 0 then
				return msg
			end

			return table.concat(client_names, ", ")
		end

		lualine.setup({
			options = {
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				theme = "auto",
				globalstatus = true,
			},

			sections = {
				lualine_a = {
					{
						"mode",
						color = { gui = "bold" },
					},
				},
				lualine_b = {
					{ "branch", icon = "" },
					{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
				},
				lualine_c = {
					{
						file_with_icon,
					},
				},
				lualine_x = {
					{
						lsp_name,
						icon = " LSP -",
					},
				},
				lualine_y = {
					{
						"diagnostics",
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
					},
					{ curr_dir },
				},
				lualine_z = {},
			},
		})
	end,
}
