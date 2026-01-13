return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        local ts = require('nvim-treesitter')

        ts.install({
            -- nvim basics
            "lua", "vim", "vimdoc", "query", "luadoc", "luap",

            --- web
            "tsx", "typescript", "javascript", "html", "css", "scss", "graphql",

            --- some common langs
            "rust", "python", "bash", "fish", "go", "ninja", "cpp", "c",

            --- configs and data
            "json", "jsonc", "yaml", "toml", "kdl", "ron", "dockerfile", "terraform",

            --- md and other
            "markdown", "markdown_inline", "mermaid", "latex",

            --- git stuff
            "git_config", "git_rebase", "gitcommit", "gitignore", "diff",

            --- whatever why not
            "regex", "printf", "sql", "make"
        })

        vim.api.nvim_create_autocmd('FileType', {
            callback = function(args)
                local buf = args.buf
                local ft = vim.bo[buf].filetype

                if ft == "" or ft:match("snacks_") then return end

                local lang = vim.treesitter.language.get_lang(ft) or ft

                local ok, parser_info = pcall(vim.treesitter.language.add, lang)
                if not ok or not parser_info then
                    return
                end

                pcall(vim.treesitter.start, buf, lang)
            end,
        })
    end
}
-- vim.keymap.set("n", "<C-space>", function()
--     local node = vim.treesitter.get_node()
--     if node then
--         local start_row, start_col, end_row, end_col = node:range()
--         vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
--         vim.cmd("normal! v")
--         vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col - 1 })
--     end
-- end)
--
