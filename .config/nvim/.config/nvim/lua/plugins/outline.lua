return {
    "hedyhli/outline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
        { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle Outline" },
    },
    opts = {
        outline_window = {
            width = 35,
        },
    },
}
