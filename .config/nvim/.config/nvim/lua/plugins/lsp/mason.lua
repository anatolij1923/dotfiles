return {
    "williamboman/mason.nvim",
    -- lazy = false,
    event = "VeryLazy",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function()
        -- import mason and mason_lspconfig
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            automatic_enable = false,
            -- servers for mason to install
            ensure_installed = {
                "lua_ls",
                "cssls",
                "clangd",
                "html",
                "ts_ls",
                "eslint",
                "emmet_language_server",
                "pyright",
                "marksman",
                "hyprls",
            },
        })

        mason_tool_installer.setup({
            automatic_enable = true,
            ensure_installed = {
                "bash-language-server",
                "prettier",
                "stylua",
                "clang-format",
                "eslint_d",
                "black",
                "denols",
                "pylint",
                -- "rust-analyzer",
                "qmlls",
                "nixfmt",
                "shfmt",
            },
        })
    end,
}
