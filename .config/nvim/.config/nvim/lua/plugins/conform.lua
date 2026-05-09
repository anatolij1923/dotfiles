return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            toml = { "tombi" },
        },

        format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
    keys = {
        {
            "gw",
            mode = { "n", "v" },
            function()
                require("conform").format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                })
            end,
            { desc = "Format file" },
        },
    },
}
