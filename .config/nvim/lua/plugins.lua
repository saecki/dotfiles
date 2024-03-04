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
            -- for multicursors.nvim
            dependencies = { "smoka7/hydra.nvim" },
            config = function()
                require("config.lualine").setup()
            end,
        },
        {
            "echasnovski/mini.hipatterns",
            config = function()
                require("config.mini_hipatterns").setup()
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
        {
            "smoka7/multicursors.nvim",
            dependencies = { "smoka7/hydra.nvim" },
            config = function()
                require("config.multicursors").setup()
            end,
        },

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
            "nvimtools/none-ls.nvim",
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
                { "nvim-treesitter/nvim-treesitter-textobjects" },
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
            dependencies = {
                -- for the attach function
                "neovim/nvim-lspconfig",
            },
            config = function()
                require("config.crates").setup()
            end,
        },

        -- Lua/Teal
        {
            "teal-language/vim-teal",
            ft = { "teal" },
        },

        -- Typst
        {
            "kaarmu/typst.vim",
            ft = { "typst" },
        },

        -- Discord rich presence
        {
            "andweeb/presence.nvim",
            config = function()
                require("config.presence").setup()
            end,
        },
    })

    -- zig.vim is installed by the system package manager on fedora
    require("config.lang.zig").setup()

    -- some rust things
    require("config.lang.rust").setup()

    -- some lua things
    require("config.lang.lua").setup()

    local wk = require("which-key")
    wk.register({
        ["<leader>p"] = { ":Lazy<cr>", "Toggle Plugins UI" },
    })
end

return M
