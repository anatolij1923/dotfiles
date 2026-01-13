return {
    {
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

            local selection_stack = {}

            vim.keymap.set({ "n", "x" }, "<CR>", function()
                local buf = vim.api.nvim_get_current_buf()
                local mode = vim.fn.mode()

                local node = vim.treesitter.get_node()
                if not node then return end

                if mode == "n" then
                    selection_stack = {}
                end

                local sr, sc, er, ec = node:range()
                local curr_range = { sr, sc, er, ec }

                if mode == "v" or mode == "V" then
                    local parent = node:parent()
                    while parent and vim.deep_equal({ parent:range() }, curr_range) do
                        parent = parent:parent()
                    end

                    if parent then
                        table.insert(selection_stack, curr_range)
                        node = parent
                    else
                        return
                    end
                end

                local n_sr, n_sc, n_er, n_ec = node:range()

                if vim.fn.mode() ~= "v" then
                    vim.cmd("normal! v")
                end

                vim.api.nvim_win_set_cursor(0, { n_sr + 1, n_sc })
                vim.cmd("normal! o")
                vim.api.nvim_win_set_cursor(0, { n_er + 1, math.max(0, n_ec - 1) })
            end, { desc = "TS: Expand selection" })

            vim.keymap.set("x", "<BS>", function()
                if #selection_stack == 0 then
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                    return
                end

                local prev_range = table.remove(selection_stack)

                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                vim.schedule(function()
                    vim.cmd("normal! v")
                    vim.api.nvim_win_set_cursor(0, { prev_range[1] + 1, prev_range[2] })
                    vim.cmd("normal! o")
                    vim.api.nvim_win_set_cursor(0, { prev_range[3] + 1, math.max(0, prev_range[4] - 1) })
                end)
            end, { desc = "TS: Shrink selection" })
        end

    },
    {
        {
            "MeanderingProgrammer/treesitter-modules.nvim",
            dependencies = { "nvim-treesitter/nvim-treesitter" },
            opts = {
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>",
                        node_incremental = "<CR>",
                        node_decremental = "<BS>",
                        scope_incremental = "<S-CR>",
                    },
                },
            },
        },
    },

}
--
