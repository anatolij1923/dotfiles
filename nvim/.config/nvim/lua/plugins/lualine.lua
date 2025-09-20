return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")
        local devicons = require("nvim-web-devicons")

        lualine.setup({
            options = {
                -- section_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
            },

            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    {
                        "filetype",
                        symbols = {
                            modified = "●",
                            readonly = "",
                            unnamed = "[No Name]",
                            newfile = "[New]",
                        },
                    },
                    "diagnostics"
                },
                lualine_c = {},
                lualine_x = {},
                lualine_y = {"diff"},
                lualine_z = { "branch" },
            },
        })
    end,
}
