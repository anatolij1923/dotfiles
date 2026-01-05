local opt = vim.opt

-- Numbers and gutter
opt.number = true
opt.relativenumber = false
opt.signcolumn = "no"

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

-- Folding (optimized for nvim-ufo)
opt.foldcolumn = "0"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Better scroll
opt.smoothscroll = true

-- Clipboard sync with a slight delay for better startup performance
vim.schedule(function()
    opt.clipboard = "unnamedplus"
end)
