local map = vim.keymap.set
local opts = { noremap = true, silent = true }
      
-- Копировать выделенный текст в системный буфер обмена по Ctrl+C
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })


map("n", "<Space>", "", opts)
vim.g.mapleader = " "

vim.keymap.set("n", "\\", ":Neotree toggle<CR>", { noremap = true, silent = true })
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>fg", ":Telescope live_grep<CR>", opts)

-- Comments
vim.keymap.set("n", "<leader>/", function()
    require("Comment.api").toggle.linewise.current()
end, { noremap = true, silent = true })

vim.keymap.set("v", "<leader>/", function()
    require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { noremap = true, silent = true })

-- Переключение между буферами с помощью Tab
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })

-- Закрытие вкладки
map("n", "<leader>q", "<Cmd>bdelete<CR>", {
  noremap = true,
  silent = true,
  desc = "Buffer: Close current" -- Описание для WhichKey
})

