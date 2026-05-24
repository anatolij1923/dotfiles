return {
	"neovim/nvim-lspconfig",

	dependencies = {
		"williamboman/mason.nvim",
	},

	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local ensure_installed = {
			"vtsls",
			"svelte-language-server",
			"lua-language-server",
			"fish-lsp",
			"rust-analyzer",
			"tombi",
			"stylua",
			"gopls",
			"tree-sitter-cli",
			"prettier",
			"clangd",
		}

		local mr = require("mason-registry")
		for _, tool in ipairs(ensure_installed) do
			local p = mr.get_package(tool)
			if not p:is_installed() then
				vim.notify("Installing " .. tool, vim.log.levels.INFO, { title = "mason.nvim" })
				p:install()
			end
		end

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		vim.lsp.config("*", { capabilities = capabilities })

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if not client then
					return
				end

				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
				end

				map("gr", function()
					Snacks.picker.lsp_references()
				end, "References")
				map("gd", function()
					Snacks.picker.lsp_definitions()
				end, "Go to Definition")
				map("gi", function()
					Snacks.picker.lsp_implementations()
				end, "Implementations")
				map("gy", function()
					Snacks.picker.lsp_type_definitions()
				end, "Type Definition")
				map("<leader>D", function()
					Snacks.picker.diagnostics_buffer()
				end, "Buffer Diagnostics")
				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("<leader>rn", vim.lsp.buf.rename, "Rename")
				map("<leader>a", vim.lsp.buf.code_action, "Code Action")
				map("<leader>d", vim.diagnostic.open_float, "Show line diagnostics")

				if client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
				end

				-- if client:supports_method('textDocument/formatting') then
				--     vim.api.nvim_create_autocmd('BufWritePre', {
				--         buffer = ev.buf,
				--         callback = function()
				--             vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
				--         end,
				--     })
				-- end
			end,
		})

		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		}

		vim.diagnostic.config({
			signs = {
				text = signs, -- Enable signs in the gutter
			},
			virtual_text = true, -- Specify Enable virtual text for diagnostics
			underline = true, -- Specify Underline diagnostics
			update_in_insert = false, -- Keep diagnostics active in insert mode
		})

		vim.lsp.config("lua_ls", {
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = { callSnippet = "Replace" },
					workspace = {
						checkThirdParty = false,
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		vim.lsp.config("vtsls", {
			cmd = { "vtsls", "--stdio" },
			filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		})

		vim.lsp.config("fish-lsp", {
			cmd = { "fish-lsp", "start" },
			filetypes = { "fish" },
		})

		vim.lsp.config("rust-analyzer", {
			cmd = { "rust-analyzer" },
			filetypes = { "rust" },
		})

		vim.lsp.config("tombi", {
			cmd = { "tombi", "lsp" },
			filetypes = { "toml" },
		})

		vim.lsp.config("gopls", {
			cmd = { "gopls" },
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
		})

		vim.lsp.config("markdown_oxide", {
			cmd = { "markdown-oxide" },
			filetypes = { "markdown" },
		})

		vim.lsp.config("clangd", {
			cmd = { "clangd" },
			filetypes = { "c", "cpp", "h", "hpp", "objc", "objcpp", "cuda" },
		})

		vim.lsp.config("qmlls", {
			cmd = { "qmlls" },
			filetypes = { "qml", "qmljs" },
		})

		vim.lsp.config("svelte-language-server", {
			cmd = { "svelteserver", "--stdio" },
			filetypes = { "svelte" },
			settings = {
				typescript = {
					inlayHints = {
						parameterNames = {
							enabled = "literals",
							suppressWhenArgumentMatchesName = true,
						},
						parameterTypes = { enabled = true },
						variableTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						enumMemberValues = { enabled = true },
					},
				},
			},
			root_dir = function(bufnr, on_dir)
				local fname = vim.api.nvim_buf_get_name(bufnr)
				if vim.uv.fs_stat(fname) ~= nil then
					local root_markers = {
						"package-lock.json",
						"yarn.lock",
						"pnpm-lock.yaml",
						"bun.lockb",
						"bun.lock",
						"deno.lock",
						".git",
					}
					local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
					on_dir(project_root)
				end
			end,
		})

		vim.lsp.enable({
			"lua_ls",
			"vtsls",
			"fish-lsp",
			"rust-analyzer",
			"tombi",
			"gopls",
			"markdown_oxide",
			"clangd",
			"qmlls",
			"svelte-language-server",
		})
	end,
}
