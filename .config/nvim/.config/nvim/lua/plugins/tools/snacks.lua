return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,

		opts = {
			dashboard = {
				enabled = true,
				preset = {
					header = {
						[[
         ▄▄    ▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄ ▄▄   ▄▄ 
        █  █  █ █       █       █  █ █  █   █  █▄█  █
        █   █▄█ █    ▄▄▄█   ▄   █  █▄█  █   █       █
        █       █   █▄▄▄█  █ █  █       █   █       █
        █  ▄    █    ▄▄▄█  █▄█  █       █   █       █
        █ █ █   █   █▄▄▄█       ██     ██   █ ██▄██ █
        █▄█  █▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█ █▄▄▄█ █▄▄▄█▄█   █▄█

                        ]],
					},
				},
			},

			indent = { enabled = true },

			notifier = { enabled = true },

			input = { enabled = true },

			terminal = { enabled = true },

			animate = { enabled = true },
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
				"<leader>/",
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
				"<C-t>",
				function()
					Snacks.terminal.toggle()
				end,
				desc = "Terminal",
			},
			{
				"<leader>fb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fp",
				function()
					Snacks.picker.projects()
				end,
				desc = "Projects",
			},
		},
	},
}
