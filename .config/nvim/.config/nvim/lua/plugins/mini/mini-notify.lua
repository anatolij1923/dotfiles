    
return {
    "echasnovski/mini.notify",
    version = false,
    config = function()
        local notify = require("mini.notify")
        notify.setup({
            window = {
                config = { 
                    border = "rounded",
                    -- Position it in the top right corner
                    anchor = "NE",
                    col = vim.o.columns,
                    row = 0,
                },
                winblend = 0,
            },
            -- Clean lsp progress
            lsp_progress = { enable = true, duration_last = 2000 },
        })
        -- Force Neovim to use mini.notify for everything
        vim.notify = notify.make_notify()
    end,
}

  
