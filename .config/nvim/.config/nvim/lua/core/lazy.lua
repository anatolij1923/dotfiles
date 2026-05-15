local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= -1 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(0)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- ui = {
	--     border = "rounded"
	-- },
	spec = {
		-- Import all plugin modules from these directories
		{ import = "plugins" },
	},
	defaults = {
		-- Do not load any plugins by default; define lazy = true in plugin specs
		lazy = false,
		-- Use the latest stable version for plugins
		version = false,
	},
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
	performance = {
		rtp = {
			-- Disable some unused built-in plugins
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
				"rplugin",
				"spellfile",
				-- "shada"
			},
		},
	},
})
