local map = vim.keymap.set

local opts = { noremap = true, silent = true }

-- Sync clipboard
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', opts)

map("n", ";", ":")

map("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>fg", ":Telescope live_grep<CR>", opts)

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected region down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected region up" })

-- Move lines left and right
vim.keymap.set("v", ">", ">gv", opts)
vim.keymap.set("v", "<", "<gv", opts)

-- Center in search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Remove search highlight
vim.keymap.set("n", "<C-c>", ":nohl<CR>")

-- split management
-- split window vertically
vim.keymap.set("n", "<leader>v", "<C-w>v", { desc = "Split window vertically" })
-- split window horizontally
vim.keymap.set("n", "<leader>h", "<C-w>s", { desc = "Split window horizontally" })
-- make split windows equal width & height
vim.keymap.set("n", "<leader>e", "<C-w>=", { desc = "Make splits equal size" })
-- close current split window
vim.keymap.set("n", "<leader>x", "<cmd>close<CR>", { desc = "Close current split" })

-- Switch tabs
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", opts)

-- Close tab
map("n", "<leader>q", "<Cmd>bdelete<CR>", {
    noremap = true,
    silent = true,
    desc = "Buffer: Close current"
})

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

