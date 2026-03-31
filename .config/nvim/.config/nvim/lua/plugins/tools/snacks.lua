return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            dashboard = {
                enabled = true,
                preset = {
                    pick = function(cmd, opts)
                        return Snacks.picker[cmd](opts)
                    end,

                    -- header = [[
                    --     ▄▄    ▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄ ▄▄   ▄▄
                    --    █  █  █ █       █       █  █ █  █   █  █▄█  █
                    --    █   █▄█ █    ▄▄▄█   ▄   █  █▄█  █   █       █
                    --    █       █   █▄▄▄█  █ █  █       █   █       █
                    --    █  ▄    █    ▄▄▄█  █▄█  █       █   █       █
                    --    █ █ █   █   █▄▄▄█       ██     ██   █ ██▄██ █
                    --    █▄█  █▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█ █▄▄▄█ █▄▄▄█▄█   █▄█
                    --      ]],

                    keys = {
                        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
                        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
                        { icon = " ", key = "g", desc = "Grep", action = ":lua Snacks.picker.grep()" },
                        { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
                        { icon = " ", key = "b", desc = "Buffers", action = ":lua Snacks.picker.buffers()" },
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
                    { section = "keys",   gap = 1, padding = 1 },
                    { section = "startup" },
                },
            },
            indent = { enabled = true },
            notifier = {},
            scope = { enabled = true },
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
