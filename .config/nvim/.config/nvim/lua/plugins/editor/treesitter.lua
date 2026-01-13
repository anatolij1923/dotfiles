return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("ts_smart_install", { clear = true }),
            callback = function(event)
                local buf = event.buf

                if vim.bo[buf].buftype ~= "" then return end

                local ft = vim.bo[buf].filetype
                if ft == "" or ft == "gitcommit" then return end

                local lang = vim.treesitter.language.get_lang(ft) or ft
                -- if ft == "typescriptreact" then lang = "tsx" end
                -- if ft == "javascriptreact" then lang = "jsx" end

                local all_parsers = ts.get_available()
                if not vim.tbl_contains(all_parsers, lang) then return end

                local parser_exists = #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) > 0

                if not parser_exists then
                    vim.notify("Treesitter: installing parser for " .. lang, vim.log.levels.INFO)

                    local ok, job = pcall(ts.install, lang)
                    if ok and job then
                        job:wait(5000)

                        vim.schedule(function()
                            if vim.api.nvim_buf_is_valid(buf) then
                                pcall(vim.treesitter.start, buf, lang)
                            end
                        end)
                    end
                else
                    pcall(vim.treesitter.start, buf, lang)
                end

                if parser_exists or not parser_exists then -- проверяем еще раз после возможной установки
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    vim.wo.foldmethod = 'expr'
                    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                end
            end
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
