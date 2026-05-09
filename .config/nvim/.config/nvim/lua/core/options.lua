local opt = vim.opt

-- General
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.cursorline = true        -- highlight current line...
opt.cursorlineopt = "number" -- ...but only highlight current line number
opt.signcolumn = "yes"       -- always show signcolumn to prevent text jumping
opt.scrolloff = 10
opt.showmode = false
opt.title = true
opt.laststatus = 3        -- one global statusline for all splits
opt.smoothscroll = true   -- smooth scrolling for wrapped lines
opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode

-- UI cleanup
opt.fillchars:append({
    eob = " ", -- hide nasty '~' on empty lines at the end of buffer
    fold = " ", -- hide dots in folds
    foldopen = "",
    foldsep = " ",
    foldclose = "",
})

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- System
opt.mouse = "a"
opt.confirm = true   -- confirm before exit
opt.undofile = true  -- persistent undo history
opt.swapfile = false -- fuck that
opt.backup = false
opt.updatetime = 250 -- faster completion and diagnostics update
opt.timeoutlen = 500 -- time to wait for a mapped sequence

-- Splits
opt.splitright = true
opt.splitbelow = true
opt.equalalways = false

-- TS folds
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldlevelstart = 99
opt.foldlevel = 99
opt.foldtext = ""
opt.foldcolumn = "0"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Clipboard
-- smart people told me that scheduling this make neovim BLAZING fast
-- they wouldn't lie. would they?
vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)
