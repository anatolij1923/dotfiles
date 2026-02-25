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
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
				end

				map("gr", function()
					Snacks.picker.lsp_references()
				end, "References")

				map("gD", function()
					Snacks.picker.lsp_declarations()
				end, "Go to Declaration")

				map("gd", function()
					Snacks.picker.lsp_definitions()
				end, "Go to Definition")

				map("gi", function()
					Snacks.picker.lsp_implementations()
				end, "Implementations")

				map("gt", function()
					Snacks.picker.lsp_type_definitions()
				end, "Type Definition")

				map("<leader>vca", vim.lsp.buf.code_action, "Code Action")

				map("<leader>rn", vim.lsp.buf.rename, "Rename")

				map("<leader>D", function()
					Snacks.picker.diagnostics_buffer()
				end, "Buffer diagnostics")

				map("<leader>d", vim.diagnostic.open_float, "Show line diagnostics")

				map("K", vim.lsp.buf.hover, "Hover Documentation")

				map("<leader>rs", ":LspRestart<CR>", "Restart LSP")

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
				text = signs, -- Enable signs in the gutter
			},
			virtual_text = true, -- Specify Enable virtual text for diagnostics
			underline = true, -- Specify Underline diagnostics
			update_in_insert = false, -- Keep diagnostics active in insert mode
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

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
			filetypes = { "html", "typescriptreact", "javascriptreact", "svelte" },
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
					-- css = true,
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

		-- tailwindcss
		vim.lsp.config["tailwindcss"] = {
			cmd = { "tailwindcss-language-server", "--stdio" },
			filetypes = { "html", "typescriptreact", "javascriptreact", "vue", "svelte", "css", "scss" },
			-- root_dir = function(fname)
			-- 	return require("lspconfig.util").root_pattern("tailwind.config.js", "package.json", ".git")(fname)
			-- end,
			settings = {
				tailwindCSS = {
					lint = {
						cssConflict = "warning",
						invalidApply = "error",
						invalidScreen = "error",
						invalidVariant = "error",
					},
					validate = true,
					experimental = {
						classRegex = {
							-- Для React/Vue
							'className="([^"]*)"',
							"class:([\\w-]+)",
						},
					},
				},
			},
			capabilities = capabilities,
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
			settings = {
				typescript = {
					preferences = {
						includePackageJsonAutoImports = "on",
						includeCompletionsForModuleExports = true,
						importModuleSpecifierPreference = "non-relative",
					},
				},
			},

			cmd = { "typescript-language-server", "--stdio" },
		}

		vim.lsp.config["vtsls"] = {
			cmd = { "vtsls", "--stdio" },
			filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
			-- root_dir = function(fname)
			-- 	return util.root_pattern(
			-- 		"apps/server/tsconfig.json",
			-- 		"apps/player/tsconfig.json",
			-- 		"apps/host/tsconfig.json",
			-- 		"packages/schema/tsconfig.json",
			-- 		"package.json"
			-- 	)(fname)
			-- end,
			settings = {
				typescript = {
					preferences = {
						includePackageJsonAutoImports = "on",
						includeCompletionsForModuleExports = true,
						importModuleSpecifierPreference = "non-relative",
					},
				},
				javascript = {
					preferences = {
						includePackageJsonAutoImports = "on",
						includeCompletionsForModuleExports = true,
						importModuleSpecifierPreference = "non-relative",
					},
				},
			},
			capabilities = capabilities,
		}
		vim.lsp.config["svelte-language-server"] = {
			cmd = { "svelteserver", "--stdio" },
			filetypes = { "svelte" },
			capabilities = capabilities,
			root_markers = { "package.json", ".git", "svelte.config.js" },
			settings = {
				svelte = {
					plugin = {
						svelte = {
							enable = true,
						},
						typescript = {
							enable = true,
						},
					},
				},
			},
		}
		--
		-- python
		vim.lsp.config["pyright"] = {
			filetypes = { "python" },
			capabilities = capabilities,
		}
		vim.lsp.config["qmlls"] = {
			cmd = { "qmlls6" },
			filetypes = { "qml" },
			capabilities = capabilities,
		}

		vim.lsp.config["nil_ls"] = {
			capabilities = capabilities,
			filetypes = { "nix" },
			root_markers = { "flake.nix" },
		}

		-- bash
		vim.lsp.config["bashls"] = {
			capabilities = capabilities,
			cmd = { "bash-language-server", "start" },
			filetypes = { "bash", "sh" },
		}
		-- markdown
		vim.lsp.config["marksman"] = {
			capabilities = capabilities,
			filetypes = { "markdown" },
		}

		vim.lsp.config["hyprls"] = {
			capabilities = capabilities,
			cmd = { "hyprls" },
			filetypes = { "hyprlang" },
			root_markers = { ".git", ".hyprlsignore" },
			settings = {
				hyprls = {
					preferIgnoreFile = true,
					ignore = { "hyprlock.conf", "hypridle.conf" },
				},
			},
		}

		-- enable lsp servers
		vim.lsp.enable({
			"lua_ls",
			"html-lsp",
			"emmet_language_server",
			"cssls",
			"tailwindcss",
			"svelte-language-server",
			-- "ts_ls",
			"vtsls",
			"clangd",
			"pyright",
			-- "rust-analyzer",
			"qmlls",
			"nil_ls",
			"bashls",
			"marksman",
			"hyprls",
		})
	end,
}
