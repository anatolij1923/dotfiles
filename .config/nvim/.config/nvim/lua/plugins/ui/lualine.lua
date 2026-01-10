return {
    "nvim-lualine/lualine.nvim",
    event = "BufReadPre",

    config = function()
        local lualine = require("lualine")

        local function curr_dir()
            local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            return "  " .. dir_name
        end

        -- Component 1: Only the Icon
        local function file_icon()
            local filename = vim.fn.expand("%:t")
            if filename == "" then
                return ""
            end
            local icon, _ = MiniIcons.get("file", filename)
            return icon
        end

        -- Component 2: Filename and Status
        local function file_name()
            local filename = vim.fn.expand("%:t")
            if filename == "" then
                filename = "[No Name]"
            end

            local status = ""
            if vim.bo.modified then
                status = " ●"
            elseif vim.bo.readonly then
                status = " "
            end

            return filename .. status
        end

        local function lsp_name()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
                return "No active LSP"
            end

            local names = {}
            for _, client in ipairs(clients) do
                table.insert(names, client.name)
            end
            return table.concat(names, ", ")
        end

        lualine.setup({
            options = {
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = { statusline = { "dashboard", "alpha", "starter", "snacks_dashboard" } },
            },
            sections = {
                lualine_a = {
                    { "mode", color = { gui = "bold" } },
                },
                lualine_b = {
                    { "branch", icon = "" },
                    { "diff", symbols = { added = " ", modified = " ", removed = " " } },
                },
                lualine_c = {
                    -- First part: Icon with dynamic color
                    {
                        file_icon,
                        padding = { left = 1, right = 0 }, -- tight fit to filename
                        color = function()
                            local filename = vim.fn.expand("%:t")
                            local _, hl = MiniIcons.get("file", filename)
                            local data = vim.api.nvim_get_hl(0, { name = hl, link = false })
                            if data and data.fg then
                                return { fg = string.format("#%06x", data.fg) }
                            end
                        end,
                    },
                    -- Second part: Filename with default color
                    {
                        file_name,
                        padding = { left = 1, right = 1 },
                    },
                },
                lualine_x = {
                    { lsp_name, icon = "LSP:" },
                },
                lualine_y = {
                    { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
                    { curr_dir },
                },
                lualine_z = {
                    { "location" },
                },
            },
        })
    end,
}
