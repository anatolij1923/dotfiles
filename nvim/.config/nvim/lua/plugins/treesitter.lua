require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = { "lua", "python", "bash", "c", "cpp", "html", "css", "javascript" },
})
