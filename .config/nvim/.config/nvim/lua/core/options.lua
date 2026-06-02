local o = vim.opt

-- General
o.number = true
o.relativenumber = true
o.termguicolors = true
o.cursorline = true -- highlight current line...
o.cursorlineopt = "number" -- ...but only highlight current line number
o.signcolumn = "yes" -- always show signcolumn to prevent text jumping
o.scrolloff = 10
o.showmode = false
o.title = true
o.laststatus = 3 -- one global statusline for all splits
o.smoothscroll = true -- smooth scrolling for wrapped lines
o.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode

-- UI cleanup
o.fillchars:append({
	eob = " ", -- hide nasty '~' on empty lines at the end of buffer
	fold = " ", -- hide dots in folds
	foldopen = "",
	foldsep = " ",
	foldclose = "",
})

-- Search
o.ignorecase = true
o.smartcase = true

-- Indentation
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.autoindent = true

-- System
o.mouse = "a"
o.confirm = true -- confirm before exit
o.undofile = true -- persistent undo history
o.swapfile = false -- fuck that
o.backup = false
o.updatetime = 250 -- faster completion and diagnostics update
o.timeoutlen = 500 -- time to wait for a mapped sequence

-- Splits
o.splitright = true
o.splitbelow = true
o.equalalways = false

-- TS folds
o.foldenable = true
o.foldmethod = "expr"
o.foldlevelstart = 99
o.foldlevel = 99
o.foldtext = ""
o.foldcolumn = "0"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Clipboard
-- smart people told me that scheduling this make neovim BLAZING fast
-- they wouldn't lie. would they?
vim.schedule(function()
	o.clipboard = "unnamedplus"
end)
