return {
  "nvim-mini/mini.nvim",
  keys = {
    {
      "-",
      function()
        local bufname = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.filereadable(bufname) == 1 and bufname or vim.fn.getcwd()
        require("mini.files").open(path)
      end,
      desc = "Open mini.files",
    },
  },
  config = function()
    local minifiles = require("mini.files")
    minifiles.setup({
      mappings = {
        close       = "q",
        go_in       = "l",
        go_in_plus  = "L",
        go_out      = "h",
        go_out_plus = "H",
        -- Use = to apply changes (rename, create, delete)
        synchronize = "=",
      },
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 30,
      },
      options = {
        use_as_default_explorer = true,
      },
    })

    -- Creating custom entries (like Enter to open or apply)
    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "MiniFilesBufferCreate",
    --   callback = function(args)
    --     local buf_id = args.data.buf_id
    --     -- Tries to go in, and if it is a file, closes the explorer
    --     vim.keymap.set("n", "<CR>", minifiles.go_in_plus, { buffer = buf_id, desc = "Open and close" })
    --   end,
    -- })
  end,
}
