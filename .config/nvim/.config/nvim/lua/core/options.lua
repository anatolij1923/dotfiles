local opt = vim.opt

-- Numbers and gutter
opt.number = true
opt.relativenumber = false
opt.signcolumn = "yes"

-- Search behavior
opt.ignorecase = true
opt.smartcase = true

-- Tabs and indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Appearance
opt.termguicolors = true
opt.cursorline = false
opt.scrolloff = 10
opt.showmode = false
opt.title = true
opt.fillchars:append({ eob = " " })

-- Behavior and performance
opt.mouse = "a"
opt.confirm = true
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.updatetime = 250
opt.timeoutlen = 500

-- Splits
opt.splitright = true
opt.splitbelow = true
opt.equalalways = false

-- Better scroll
opt.smoothscroll = true

-- Folding (optimized for nvim-ufo)
opt.foldcolumn = "0"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
