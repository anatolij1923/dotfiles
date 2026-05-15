local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<ESC>", "<cmd>nohl<CR>", { desc = "Clear search highlight" })
map("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })
map("n", "<leader>/", "gcc", { remap = true, desc = "Comment line" })
map("v", "<leader>/", "gc", { remap = true, desc = "Comment selection" })

-- Remove this BS bind
vim.keymap.set("n", "q:", "<nop>", { noremap = true, silent = true })

-- Save on enter, uses <CR> to save in normal buffers, but keeps original behavior in popups
map("n", "<CR>", function()
	local ignore_buftypes = { "quickfix", "nofile", "help", "terminal", "prompt" }
	local ignore_filetypes = { "lazy", "mason", "snacks_picker_input" }

	if
		vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
		or vim.tbl_contains(ignore_filetypes, vim.bo.filetype)
		or vim.bo.readonly
	then
		return "<CR>"
	end
	return "<cmd>update<CR>"
end, { expr = true, desc = "Smart save on enter" })

-- Better movement
map("n", "n", "nzzzv", { desc = "Center search next" })
map("n", "N", "Nzzzv", { desc = "Center search previous" })

-- Line indenting
map("v", "<", "<gv", { desc = "Indent left and keep selection" })
map("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- Move lines in visual mode
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move block up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move block down" })

-- Splits management
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sq", "<cmd>close<CR>", { desc = "Close current split" })

-- Tabs
map("n", "<leader><Tab>n", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader><Tab>q", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader><Tab>h", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader><Tab>l", "<cmd>tabnext<CR>", { desc = "Next tab" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Buffer management (placeholders for bufferline/snacks)
map("n", "<Tab>", "<cmd>bn<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bp<CR>", { desc = "Previous buffer" })
map("n", "<leader>q", function()
	Snacks.bufdelete()
end, { desc = "Close current buffer" })

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("n", "<M-o>", "van", { desc = "TS: Start incremental selection", remap = true })
map("x", "<M-o>", "an", { desc = "TS: Increment selection", remap = true })
map("x", "<M-i>", "in", { desc = "TS: Decrement selection", remap = true })

-- undotree
vim.keymap.set("n", "<leader>u", "<cmd>Undotree<CR>", { desc = "Open undotree" })
