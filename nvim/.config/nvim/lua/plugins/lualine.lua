return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")
        lualine.setup()
    end,
}
