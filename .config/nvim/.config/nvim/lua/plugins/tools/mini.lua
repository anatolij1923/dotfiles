return {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
        vim.keymap.set("n", "-", function()
            require("mini.files").open(vim.api.nvim_buf_get_name(0))
        end)

        -- mini.icons
        local icons = require("mini.icons")
        icons.setup()
        icons.mock_nvim_web_devicons()

        -- mini.pairs
        require("mini.pairs").setup()

        -- mini.notify
    end,
}
