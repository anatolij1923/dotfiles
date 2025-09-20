return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,

        opts = {
            dashboard = { enabled = true },

            indent = { enabled = true },

            notifier = { enabled = true },

            input = { enabled = true },
        },

        keys = {
            -- Lazygit
            {
                "<leader>lg",
                function()
                    Snacks.lazygit()
                end,
                desc = "Lazygit",
            },

            {
                "\\",
                function()
                    Snacks.explorer()
                end,
                desc = "File Explorer",
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
        },
    },
}
