return {
  "nvim-mini/mini.nvim",
  version = false,
  config = function()
    -- mini.files
    require("mini.files").setup({
      mappings = {
        close = "q",
        go_in = "l",
        go_out = "h",
        synchronize = "=",
      },
      windows = {
        preview = true,
        width_focus = 30,
      },
    })

    vim.keymap.set("n", "-", function()
      require("mini.files").open(vim.api.nvim_buf_get_name(0))
    end)

    -- mini.icons
    require("mini.icons").setup()

    -- mini.pairs
    require("mini.pairs").setup()

    -- mini.notify
    local notify = require("mini.notify")
    notify.setup({
      window = {
        config = {
          border = "rounded",
          anchor = "NE",      -- North-East = верхний правый угол
          col = vim.o.columns,
          row = 2,
        },
        winblend = 0,
      },
    })
    vim.notify = notify.make_notify()
  end,
}
