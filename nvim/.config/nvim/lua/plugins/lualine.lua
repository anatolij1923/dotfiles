return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")
        local devicons = require("nvim-web-devicons")

        local function curr_dir()
            local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            return "  " .. dir_name
        end

        local function file_with_icon()
            local filename = vim.fn.expand("%:t")
            local icon, icon_color = devicons.get_icon_color(filename, vim.bo.filetype, { default = true })
            if filename == "" then
                filename = "[No Name]"
                icon = ""
                icon_color = nil
            end
            local status = ""
            if vim.bo.modified then
                status = " ●" -- изменённый файл
            elseif vim.bo.readonly then
                status = " " -- только для чтения
            end

            return icon .. " " .. filename .. status, icon_color
        end

        local function hl_color(group)
            local ok, hl = pcall(vim.api.nvim_get_hl_by_name, group, true)
            if not ok then return nil end
            return hl.foreground and string.format("#%06x", hl.foreground) or nil
        end

        lualine.setup({
            options = {
                -- section_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                theme = "auto"
            },

            sections = {
                lualine_a = { {
                    "mode",
                    color = { gui = "bold" }
                } },
                lualine_b = {
                    {
                        "branch",
                        icon = ""
                    },
                    {
                        "diff",
                        symbols = { added = " ", modified = " ", removed = " " },
                    },


                },
                lualine_c = {
                    {
                        file_with_icon,
                    },
                },
                lualine_x = {
                },
                lualine_y = {
                    {
                        "diagnostics",
                        symbols = {
                            error = " ",
                            warn = " ",
                            info = " ",
                            hint = " ",
                        },
                    },
                    { curr_dir },


                },
                lualine_z = {

                },
            },
        })
    end,
}
