-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Save undo history
vim.o.undofile = true

-- Disable swap file
vim.opt.swapfile = false

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.equalalways = false

-- Decrease update time
vim.o.updatetime = 250

vim.opt.laststatus = 3

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.termguicolors = true

vim.opt.title = true

vim.opt.backup = false
vim.opt.showcmd = true

-- 2 tabwidth for js/ts
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
    end,
})

vim.o.foldcolumn = "1"    -- колонка слева для отображения фолдов
vim.o.foldlevel = 99      -- чтобы не сворачивало всё при открытии
vim.o.foldlevelstart = 99
vim.o.foldenable = true   -- включить фолды
