local M = {}

local util = require("util")

function M.setup()
    -- bootstrap lazy.nvim
    local lazypath = util.join_paths(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    local lazy = require("lazy")
    lazy.setup({
        -- Key mappings
        {
            "folke/which-key.nvim",
            config = function()
                require("config.which-key").setup()
            end,
        },

        -- Gui enhancements
        {
            "rcarriga/nvim-notify",
            priority = 100,
            config = function()
                require("config.notify").setup()
            end,
        },
        {
            "nvim-lualine/lualine.nvim",
            config = function()
                require("config.lualine").setup()
            end,
        },
        {
            "norcalli/nvim-colorizer.lua",
            config = function()
                require("config.colorizer").setup()
            end,
        },
        {
            "lukas-reineke/indent-blankline.nvim",
            config = function()
                require("config.indent-blankline").setup()
            end,
        },
        {
            "nvim-tree/nvim-web-devicons",
            config = function()
                require("config.devicons").setup()
            end,
        },

        -- Multicursor
        "mg979/vim-visual-multi",

        -- Filetree
        {
            "kyazdani42/nvim-tree.lua",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            keys = { "<leader>x", "<leader>X" },
            config = function()
                require("config.nvim-tree").setup()
            end,
        },

        -- File Search/Replace
        {
            "nvim-pack/nvim-spectre",
            dependencies = {
                { "nvim-lua/plenary.nvim" },
                { "nvim-tree/nvim-web-devicons" },
            },
            config = function()
                require("config.spectre").setup()
            end,
        },

        -- File navigation
        "farmergreg/vim-lastplace",
        {
            "nvim-telescope/telescope.nvim",
            dependencies = {
                { "nvim-lua/plenary.nvim" },
                { "nvim-tree/nvim-web-devicons" },
                { "ahmedkhalf/project.nvim" },
            },
            config = function()
                require("config.telescope").setup()
            end,
        },
        {
            "ThePrimeagen/harpoon",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                require("config.harpoon").setup()
            end,
        },

        -- Lists
        {
            "folke/trouble.nvim",
            dependencies = { "folke/todo-comments.nvim" },
            config = function()
                require("config.trouble").setup()
            end,
        },

        -- Git
        {
            "tpope/vim-fugitive",
            config = function()
                require("config.fugitive").setup()
            end,
        },
        {
            "lewis6991/gitsigns.nvim",
            config = function()
                require("config.gitsigns").setup()
            end,
        },

        -- Lsp
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                { "williamboman/mason.nvim" },
                { "nanotee/sqls.nvim" },
                { "hrsh7th/cmp-nvim-lsp" },
            },
            config = function()
                require("config.lsp").setup()
            end,
        },
        {
            "jose-elias-alvarez/null-ls.nvim",
            dependencies = { "nvim-lspconfig" },
            config = function()
                require("config.null-ls").setup()
            end,
        },
        {
            "j-hui/fidget.nvim",
            tag = "legacy",
            config = function()
                require("config.fidget").setup()
            end,
        },

        -- Debugging
        {
            "mfussenegger/nvim-dap",
            dependencies = { "rcarriga/nvim-dap-ui" },
            config = function()
                require("config.dap").setup()
            end,
        },

        -- Completion
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                { "hrsh7th/cmp-path" },
                { "hrsh7th/cmp-buffer" },
                { "hrsh7th/cmp-nvim-lua" },
                { "hrsh7th/cmp-nvim-lsp" },
                { "saadparwaiz1/cmp_luasnip" },
                { "L3MON4D3/LuaSnip" },
            },
            config = function()
                require("config.cmp").setup()
            end,
        },

        -- Snippets
        {
            "L3MON4D3/LuaSnip",
            config = function()
                require("config.luasnip").setup()
            end,
        },

        -- Comments
        {
            "numToStr/Comment.nvim",
            config = function()
                require("config.comment").setup()
            end,
        },

        -- Treesitter
        {
            "nvim-treesitter/nvim-treesitter",
            dependencies = {
                { dir = "~/Projects/nvim-treesitter-context" },
                { "nvim-treesitter/playground" },
            },
            build = function()
                vim.cmd(":TSUpdate")
            end,
            config = function()
                require("config.treesitter").setup()
            end,
        },

        -- Markdown
        {
            "plasticboy/vim-markdown",
            ft = { "markdown" },
            config = function()
                require("config.lang.markdown").setup()
            end,
        },
        {
            "iamcco/markdown-preview.nvim",
            ft = { "markdown" },
            build = function()
                vim.call("mkdp#util#install")
            end,
        },
        {
            "dhruvasagar/vim-table-mode",
            config = function()
                require("config.table-mode").setup()
            end,
        },

        -- Rust
        {
            dir = "~/Projects/crates.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                require("config.crates").setup()
            end,
        },

        -- Lua/Teal
        {
            "teal-language/vim-teal",
            ft = { "teal" },
        },

        -- Discord rich presence
        "andweeb/presence.nvim",

        -- Browser Integration
        {
            "glacambre/firenvim",
            build = function()
                vim.call("firenvim#install", 0)
            end,
            config = function()
                require("config.firenvim").setup()
            end,
        },
    })

    local wk = require("which-key")
    wk.register({
        ["<leader>p"] = { ":Lazy<cr>", "Toggle Plugins UI" },
    })
end

return M
