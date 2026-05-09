return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				header = [[
 ▄██▄       ▄█
█▄▀███▄    ███
███ ▀███▄  ███
███   ▀███ ███
███     ▀█ ███
▀██        ██▀
  ▀        ▀⠀⠀
]],

				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
					{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
					{ icon = " ", key = "g", desc = "Grep", action = ":lua Snacks.picker.grep()" },
					{
						icon = "󰒲 ",
						key = "L",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{
					section = "keys",
					gap = 1,
					padding = 1,
				},
				{ section = "startup" },
			},
		},
		indent = { enabled = true },
		input = { enabled = true },
		picker = {
			enabled = true,
			ui_select = true,
			layout = {
				preset = "telescope",
				backdrop = true,
			},
		},
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>:",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command history",
		},
		{
			"<leader>th",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Choose colorschemes",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent Files",
		},
		{
			"<leader>fw",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>n",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification History",
		},
		{
			"<leader>j",
			function()
				Snacks.terminal.toggle()
			end,
			desc = "Terminal",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.projects()
			end,
			desc = "Projects",
		},
		{
			"<leader>ks",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
	},
}
