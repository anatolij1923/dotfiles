return {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    version = false,
    keys = {
        {
            "-",
            function()
                if not MiniFiles.close() then
                    MiniFiles.open(vim.api.nvim_buf_get_name(0))
                end
            end,
            desc = "Open mini.files",
        },
    },
    config = function()
        require("mini.files").setup({
            windows = {
                preview = true,
                width_focus = 50,
                width_preview = 40,
                options = { use_as_default_explorer = true },
            },
        })

        local mini_icons = require("mini.icons")
        mini_icons.setup()
        mini_icons.mock_nvim_web_devicons()

        require("mini.pairs").setup({})

        require("mini.tabline").setup({})

        -- require("mini.statusline").setup({
        --     content = {
        --         active = function()
        --             local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        --             local git           = MiniStatusline.section_git({ trunc_width = 40 })
        --             local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
        --             local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
        --             local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
        --             local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
        --             local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        --             local location      = MiniStatusline.section_location({ trunc_width = 75 })
        --             local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })
        --
        --             local function get_macro()
        --                 local recording_register = vim.fn.reg_recording()
        --                 if recording_register == "" then return "" end
        --                 return "Recording @" .. recording_register
        --             end
        --
        --             local lsp_status = function()
        --                 local get_clients = vim.lsp.get_clients
        --                 local clients = get_clients({ bufnr = 0 })
        --                 if #clients == 0 then return "" end
        --
        --                 local names = {}
        --                 for _, client in pairs(clients) do
        --                     table.insert(names, client.name)
        --                 end
        --
        --                 local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        --                 local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        --
        --                 local str = "LSP: " .. table.concat(names, ", ")
        --                 if errors > 0 then str = str .. " E: " .. errors end
        --                 if warnings > 0 then str = str .. " W: " .. warnings end
        --                 return str
        --             end
        --
        --             local curr_line = vim.fn.line('.')
        --             local last_line = vim.fn.line('$')
        --             local custom_location = string.format('%d/%d', curr_line, last_line)
        --
        --             return MiniStatusline.combine_groups({
        --                 { hl = mode_hl,                 strings = { mode:upper() } },
        --                 { hl = 'MiniStatuslineDevinfo', strings = { git, diff } },
        --                 '%<',
        --                 { hl = 'MiniStatuslineFilename', strings = { filename } },
        --                 { hl = 'ErrorMsg',               strings = { get_macro() } },
        --                 '%=',
        --                 { hl = 'MiniStatuslineDevinfo', strings = { lsp_status() } },
        --                 { hl = mode_hl,                 strings = { custom_location } },
        --             })
        --         end
        --     }
        -- })

        --
        require("mini.surround").setup({
            mappings = {
                add = "gsa",
                delete = "gsd",
                replace = "gsr",
                find = "gsf",
                find_left = "gsF",
                highlight = "gsh",
                update_n_lines = "gsn",
            },
        })
        require("mini.ai").setup({
            mappings = {
                inside_next = "gin",
                around_next = "gan",
                around_last = "gal",
                inside_last = "gil",
            },
        })

        require("mini.bracketed").setup({})
    end,
}
