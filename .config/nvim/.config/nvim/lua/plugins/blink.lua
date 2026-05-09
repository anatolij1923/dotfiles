return {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        "saghen/blink.lib",
        "rafamadriz/friendly-snippets",
    },
    build = function()
        -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
        require("blink.cmp").build():wait(60000)
    end,

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "none",
            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<C-space>"] = { "show", "fallback" },
            ["<CR>"] = { "select_and_accept", "fallback" },
        },

        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 100 },

            ghost_text = {
                enabled = true,
                show_with_menu = true,
            },

            menu = {
                scrollbar = false,
                draw = {
                    gap = 3,
                    columns = {
                        { "label",     "label_description" },
                        { "kind_icon", "kind",             gap = 2 },
                    },
                },
            },
        },

        sources = { default = { "lsp", "path", "snippets", "buffer" } },

        fuzzy = { implementation = "rust" },
    },
}
