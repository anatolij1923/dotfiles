return {
    "nvim-mini/mini.nvim",
    init = function()
        local starter = require("mini.starter")
        starter.setup({
            -- Header: Use the ASCII logo you had before

            -- Dashboard items
            sections = {
                starter.sections.builtin_actions(),
                starter.sections.recent_files(5, false),
                starter.sections.sessions(5, true),
            },

            -- Footer: Current date and Neovim version
            footer = function()
                local datetime = os.date("%Y-%m-%d %H:%M:%S")
                local version = vim.version()
                return string.format("%s  |  v%d.%d.%d", datetime, version.major, version.minor, version.patch)
            end,

            -- Design layout
            content_hooks = {
                starter.gen_hook.adding_bullet("» "),
                starter.gen_hook.aligning("center", "center"),
            },
        })
    end,
}
