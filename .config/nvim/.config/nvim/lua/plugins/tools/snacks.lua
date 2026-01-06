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
			-- Lazygit
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
			},
			{
				"<leader>th",
				function()
					Snacks.picker.colorschemes()
				end,
			},
			{
				"<leader>ff",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
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
				"<leader>ks",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<C-t>",
				function()
					Snacks.terminal.toggle()
				end,
				desc = "Terminal",
			},
		},
	},
}
