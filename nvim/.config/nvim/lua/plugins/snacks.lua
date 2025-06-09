return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,

        opts = {
            explorer = {
                enabled = true,
                layout = {
                    cycle = false,
                },
            },

            dashboard = { enabled = true, 
                sections = {
                    {
                        section = "terminal",
                        cmd = "chafa ~/Изображения/wallpapers/trash/putin-png.png --format symbols --symbols vhalf --size 40x17 --stretch; sleep .1",
                        padding = 1,
                        height = 20,
                    },
                    {
                        pane = 2,
                        { section = "keys", gap = 1, padding = 1 },
                        { section = "startup" },
                    },
                }
            },

            indent = { enabled = true },

            notifier = { enabled = true },

            input = { enabled = true },
        },

        keys = {
            -- Lazygit
            { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },

            { "\\", function() Snacks.explorer() end, desc = "File Explorer" },
            { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
            { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
            { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
            { "<leader>ks", function() Snacks.picker.keymaps() end, desc = "Keymaps" },

            -- Other
            { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
        },

    },
}
