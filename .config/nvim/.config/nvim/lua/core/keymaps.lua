local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General
map("n", ";", ":", { desc = "Enter command mode" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<C-c>", "<cmd>nohl<CR>", { desc = "Clear search highlight" })
map("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })

-- Better movement
map("n", "n", "nzzzv", { desc = "Center search next" })
map("n", "N", "Nzzzv", { desc = "Center search previous" })

-- Visual mode line shifting
map("v", "<", "<gv", { desc = "Indent left and keep selection" })
map("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- Move lines in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move block down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move block up" })

-- Window management
map("n", "<leader>v", "<C-w>v", { desc = "Split vertically" })
map("n", "<leader>h", "<C-w>s", { desc = "Split horizontally" })
map("n", "<leader>e", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>x", "<cmd>close<CR>", { desc = "Close current split" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Buffer management (placeholders for bufferline/snacks)
map("n", "<Tab>", "<cmd>bn<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bp<CR>", { desc = "Previous buffer" })
map("n", "<leader>q", "<cmd>bdelete<CR>", { desc = "Close current buffer" })

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
