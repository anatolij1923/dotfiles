local map = vim.keymap.set
local opts = { noremap = true, silent = true }
      
-- Копировать выделенный текст в системный буфер обмена по Ctrl+C
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })


map("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>fg", ":Telescope live_grep<CR>", opts)

-- Move lines 
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Move lines left and right
vim.keymap.set("v", ">", ">gv", opts)
vim.keymap.set("v", "<", "<gv", opts)

-- Center in search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Remove search highlight
vim.keymap.set("n", "<C-c>", ":nohl<CR>")

--split management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
-- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
-- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
-- close current split window
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Переключение между буферами с помощью Tab
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })

-- Закрытие вкладки
map("n", "<leader>q", "<Cmd>bdelete<CR>", {
  noremap = true,
  silent = true,
  desc = "Buffer: Close current" -- Описание для WhichKey
})

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set("n", "<leader>ca", function()
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true, desc = 'Code Actions'})
