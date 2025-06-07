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

            dashboard = {
                enabled = true,
            }
        },

        keys = {
            -- Lazygit
            { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
            
            { "\\", function() Snacks.explorer() end, desc = "File Explorer" },        
            { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
            { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },

            -- Other
            { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
        },

    },
}
