return {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    config = function()
        require("kanagawa").setup({
            keywordStyle = { italic = false },
            transparent = false,
            compile = true,
            colors = {
                theme = {
                    all = {
                        ui = {
                            bg_gutter = "none",
                        },
                    },
                },
            },
        })
    end,
}
