return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- Buffer local mappings
                -- Check `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf, silent = true }

                -- keymaps
                opts.desc = "Show LSP references"
                vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

                opts.desc = "Go to declaration"
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

                opts.desc = "Show LSP definitions"
                vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

                opts.desc = "Show LSP implementations"
                vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

                opts.desc = "Show LSP type definitions"
                vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

                opts.desc = "See available code actions"
                vim.keymap.set({ "n", "v" }, "<leader>vca", function()
                    vim.lsp.buf.code_action()
                end, opts) -- see available code actions, in visual mode will apply to selection

                opts.desc = "Smart rename"
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

                opts.desc = "Show buffer diagnostics"
                vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

                opts.desc = "Show line diagnostics"
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

                opts.desc = "Show documentation for what is under cursor"
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                opts.desc = "Restart LSP"
                vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

                vim.keymap.set("i", "<C-h>", function()
                    vim.lsp.buf.signature_help()
                end, opts)
            end,
        })

        -- Change the Diagnostic symbols in the sign column (gutter)

        -- Define sign icons for each severity
        local signs = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
        }

        -- Set the diagnostic config with all icons
        vim.diagnostic.config({
            signs = {
                text = signs,         -- Enable signs in the gutter
            },
            virtual_text = true,      -- Specify Enable virtual text for diagnostics
            underline = true,         -- Specify Underline diagnostics
            update_in_insert = false, -- Keep diagnostics active in insert mode
        })

        local capabilities = require("blink.cmp").get_lsp_capabilities(
            vim.lsp.protocol.make_client_capabilities()
        )

        -- Setup servers

        -- lua_ls
        vim.lsp.config["lua_ls"] = {
            capabilities = capabilities,
            cmd = { "lua-language-server" },
            filetypes = { "lua" },
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    completion = { callSnippet = "Replace" },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        }

        -- emmet_language_server
        vim.lsp.config["emmet_language_server"] = {
            capabilities = capabilities,
            filetypes = { "html" },
            init_options = {
                includeLanguages = {},
                excludeLanguages = {},
                extensionsPath = {},
                preferences = {},
                showAbbreviationSuggestions = false,
                showExpandedAbbreviation = "always",
                showSuggestionsAsSnippets = false,
                syntaxProfiles = {},
                variables = {},
            },
        }

        -- html-lsp
        vim.lsp.config["html-lsp"] = {
            capabilities = capabilities,
            cmd = { "vscode-html-language-server", "--stdio" },
            filetypes = { "html" },
            root_markers = { ".git" },
            init_options = {
                configurationSection = { "html" },
                embeddedLanguages = {
                    css = true,
                    javascript = true,
                },
                provideFormatter = true,
            },
        }

        -- cssls
        vim.lsp.config["cssls"] = {
            cmd = { "vscode-css-language-server", "--stdio" },
            capabilities = capabilities,
            filetypes = { "css", "scss", "less" },
            settings = {
                css = { validate = true },
                less = { validate = true },
                scss = { validate = true },
            },
        }

        -- clangd
        vim.lsp.config["clangd"] = {
            cmd = { "clangd" },
            capabilities = capabilities,
            filetypes = { "c", "cpp", "objc", "objcpp" },
        }

        -- ts_ls
        vim.lsp.config["ts_ls"] = {
            capabilities = capabilities,
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
            cmd = { "typescript-language-server", "--stdio" },
        }
        --
        -- python
        vim.lsp.config["pyright"] = {
            filetypes = { "python" },
            capabilities = capabilities,
        }
        -- rust
        vim.lsp.config["rust_analyzer"] = {
            capabilities = capabilities,
            cmd = { "rust-analyzer" },
            filetypes = { "rust" },
            root_markers = { "Cargo.toml", "rust-project.json", ".git" },
        }
        -- qml
        vim.lsp.config["qmlls"] = {
            cmd = { "qmlls6" },
            filetypes = { "qml" },
            capabilities = capabilities,
        }

        -- enable lsp servers
        vim.lsp.enable("lua_ls")
        vim.lsp.enable("html-lsp")
        vim.lsp.enable("emmet_language_server")
        vim.lsp.enable("cssls")
        vim.lsp.enable("ts_ls")
        vim.lsp.enable("clangd")
        vim.lsp.enable("pyright")
        vim.lsp.enable("rust-analyzer")
        vim.lsp.enable("qmlls")
    end,
}
