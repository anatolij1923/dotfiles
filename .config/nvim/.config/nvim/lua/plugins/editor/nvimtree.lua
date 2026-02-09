return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { "nvim-mini/mini.nvim" },
    keys = {
        { "\\", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
    },
    config = function()
        require("nvim-tree").setup({
            disable_netrw = true,
            hijack_cursor = true,
            sync_root_with_cwd = true,

            view = {
                width = 30,
            },
            renderer = {
                icons = {
                    -- Icons will be automatically provided by mini.icons mock
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                    -- glyphs = {
                    -- 	folder = {
                    -- 		arrow_closed = "󰅂",
                    -- 		arrow_open = "󰅀",
                    -- 	},
                    -- },
                },
            },
        })
    end,
}
