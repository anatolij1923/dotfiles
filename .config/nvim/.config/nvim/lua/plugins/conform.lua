return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        local custom_formatters = {
            ["clang-format"] = {
                args = {
                    "--assume-filename", "$FILENAME",
                    "--style", "{BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never}"
                }
            },

            prettier = {
                args = {
                    "--stdin-filepath",
                    "$FILENAME",
                    "--tab-width",
                    "2",
                    "--use-tabs",
                    "false",
                }
            }
        }
        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                -- markdown = { "prettier" },
                graphql = { "prettier" },
                liquid = { "prettier" },
                lua = { "stylua" },
                python = { "black" },
                markdown = { "prettier" },
                ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                qml = { "qmlls" },
                nix = { "nixfmt" },
                bash = { "shfmt" },
                sh = { "shfmt" },
            },
            formatters = custom_formatters
            -- format_on_save = {
            -- 	lsp_fallback = true,
            -- 	async = false,
            -- 	timeout_ms = 1000,
            -- },
        })

        -- Configure individual formatters
        -- conform.formatters.prettier = {
        --     args = {
        --         "--stdin-filepath",
        --         "$FILENAME",
        --         "--tab-width",
        --         "2",
        --         "--use-tabs",
        --         "false",
        --     },
        -- }


        vim.keymap.set({ "n", "v" }, "f", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "Format whole file or range (in visual mode)" })
    end,
}
