require("lazy").setup({
    -- Визуал
    -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    -- { "ellisonleao/gruvbox.nvim", priority = 1000 },
    { "EdenEast/nightfox.nvim", priority = 1000 },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "numToStr/Comment.nvim", config = true }, -- комментарии кода
    {
     "nvim-neo-tree/neo-tree.nvim",
     branch = "v3.x",
     dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
   },

    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

    {
    "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
    },

  -- статусбар
    { "nvim-lualine/lualine.nvim" },

    {'brenoprata10/nvim-highlight-colors'},

    -- Автозакрытие скобок 
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },

    -- Навигация
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

    -- TypeScript
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },

    -- LSP и автодополнение
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    { "L3MON4D3/LuaSnip", 
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    "saadparwaiz1/cmp_luasnip",
    -- Сниппеты
    { "rafamadriz/friendly-snippets" },

    -- Менеджер LSP/форматтеров
    {
        "williamboman/mason.nvim",
        config = true
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = true
    },
})

-- загрузка конфигураций
require("luasnip.loaders.from_vscode").lazy_load()
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.cmp")
require("lualine").setup()
require("neo-tree").setup()
require("bufferline").setup()
require('nvim-highlight-colors').setup({})
-- require("catppuccin").setup({
  -- transparent_background = true,
-- })
require("nightfox").setup({})
vim.cmd.colorscheme("carbonfox")
