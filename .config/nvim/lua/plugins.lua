local M = {}

local packer = require("packer")

function M.setup()
    -- load before other plugins
    local notify_ok, notify = pcall(require, "notify")
    if notify_ok then
        vim.notify = notify
    end

    packer.startup(function(use)
        use({
            "wbthomason/packer.nvim",
            config = function()
                require("config.packer").setup()
            end,
        })

        -- Perfomance
        use("lewis6991/impatient.nvim")

        -- Key mappings
        use({
            "folke/which-key.nvim",
            config = function()
                require("config.which-key").setup()
            end,
        })

        -- Gui enhancements
        use({
            "rcarriga/nvim-notify",
            config = function()
                require("config.notify").setup()
            end,
        })
        use({
            "nvim-lualine/lualine.nvim",
            config = function()
                require("config.lualine").setup()
            end,
        })
        use({
            "RishabhRD/popfix",
            config = function()
                require("config.popfix").setup()
            end,
        })
        use({
            "norcalli/nvim-colorizer.lua",
            config = function()
                require("config.colorizer").setup()
            end,
        })
        use({
            "lukas-reineke/indent-blankline.nvim",
            config = function()
                require("config.indent-blankline").setup()
            end,
        })

        -- Multicursor
        use({
            "terryma/vim-multiple-cursors",
            config = function()
                require("config.multi-cursor").setup()
            end,
        })

        -- File navigation
        use({
            "kyazdani42/nvim-tree.lua",
            requires = { "kyazdani42/nvim-web-devicons" },
            keys = { "<f6>", "<f18>" },
            config = function()
                require("config.nvim-tree").setup()
            end,
        })
        use({
            "nvim-telescope/telescope.nvim",
            requires = {
                { "nvim-lua/plenary.nvim" },
                { "kyazdani42/nvim-web-devicons" },
            },
            config = function()
                require("config.telescope").setup()
            end,
        })
        use({
            "ahmedkhalf/project.nvim",
            requires = { "nvim-telescope/telescope.nvim" },
            config = function()
                require("config.project").setup()
            end,
        })
        use({
            "ThePrimeagen/harpoon",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("config.harpoon").setup()
            end,
        })
        use("farmergreg/vim-lastplace")
        use({
            "kyazdani42/nvim-web-devicons",
            config = function()
                require("config.devicons").setup()
            end,
        })

        -- Lists
        use({
            "folke/trouble.nvim",
            config = function()
                require("config.trouble").setup()
            end,
        })
        use({
            "folke/todo-comments.nvim",
            after = { "trouble.nvim" },
            config = function()
                require("config.todo-comments").setup()
            end,
        })

        -- Git
        use({
            "tpope/vim-fugitive",
            config = function()
                require("config.fugitive").setup()
            end,
        })
        use({
            "lewis6991/gitsigns.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("config.gitsigns").setup()
            end,
        })

        -- Lsp
        use({
            "neovim/nvim-lspconfig",
            requires = {
                { "nvim-lua/lsp-status.nvim" },
                { "williamboman/nvim-lsp-installer" },
            },
            config = function()
                require("config.lsp").setup()
            end,
        })
        use({
            "jose-elias-alvarez/null-ls.nvim",
            config = function()
                require("config.null-ls").setup()
            end,
        })

        -- Debugging
        use({
            "mfussenegger/nvim-dap",
            config = function()
                require("config.dap").setup()
            end,
        })
        use({
            "rcarriga/nvim-dap-ui",
            after = { "nvim-dap" },
            config = function()
                require("config.dap.ui").setup()
            end,
        })

        -- Completion
        use({
            "hrsh7th/nvim-cmp",
            requires = {
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
        })

        -- Snippets
        use({
            "L3MON4D3/LuaSnip",
            config = function()
                require("config.luasnip").setup()
            end,
        })

        -- Comments
        use({
            "numToStr/Comment.nvim",
            config = function()
                require("config.comment").setup()
            end,
        })

        -- Treesitter
        use({
            "nvim-treesitter/nvim-treesitter",
            requires = { "romgrk/nvim-treesitter-context" },
            run = function()
                vim.cmd(":TSUpdate")
            end,
            config = function()
                require("config.treesitter").setup()
            end,
        })
        use({
            "nvim-treesitter/playground",
            requires = { "nvim-treesitter" },
            cmd = "TSPlaygroundToggle",
        })

        -- Markdown
        use({
            "plasticboy/vim-markdown",
            ft = { "markdown" },
            config = function()
                require("config.lang.markdown").setup()
            end,
        })
        use({
            "iamcco/markdown-preview.nvim",
            ft = { "markdown" },
            run = function()
                vim.call("mkdp#util#install")
            end,
        })
        use({
            "dhruvasagar/vim-table-mode",
            config = function()
                require("config.table-mode").setup()
            end,
        })

        -- Rust
        use({
            "rust-lang/rust.vim",
            ft = { "rust" },
            config = function()
                require("config.lang.rust").setup()
            end,
        })
        use({
            "~/Projects/crates.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("config.crates").setup()
            end,
        })

        -- Lua/Teal
        use({
            "teal-language/vim-teal",
            ft = { "teal" },
        })

        -- Discord rich presence
        use("andweeb/presence.nvim")

        -- Browser Integration
        use({
            "glacambre/firenvim",
            run = function()
                vim.call("firenvim#install", 0)
            end,
            config = function()
                require("config.firenvim").setup()
            end,
        })
    end)
end

return M
