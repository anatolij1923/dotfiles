local function augroup(name)
    return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Set indentation for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("set_indent"),
    pattern = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "css",
        "scss",
        "html",
        "nix",
    },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("textyankpost", {
    group = augroup("highlight_yank"),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = augroup("resize_splits"),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})
