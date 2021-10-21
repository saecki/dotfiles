local M = {}

function M.setup()
    require('packer').startup(function(use)
        use { 'wbthomason/packer.nvim' }

        -- Gui enhancements
        use {
            'rcarriga/nvim-notify',
            config = function()
                vim.notify = require('notify')
            end,
        }
        use { 'hoob3rt/lualine.nvim' }

        -- Multicursor
        use {
            'terryma/vim-multiple-cursors',
            config = function()
                require('config.multi-cursor').setup()
            end,
        }

        -- Fuzzy finding
        use { 'airblade/vim-rooter' }
        use {
            'nvim-telescope/telescope.nvim',
            requires = { { 'nvim-lua/plenary.nvim' } },
            config = function()
                require('config.telescope').setup()
            end,
        }

        -- Filetree
        use {
            'kyazdani42/nvim-tree.lua',
            keys = { "<f6>", "<f18>" },
            config = function()
                require('config.nvim-tree').setup()
            end,
        }

        -- Lists
        use {
            'saecki/trouble.nvim',
            branch = "provider",
            config = function()
                require('config.trouble').setup()
            end,
        }
        use {
            'folke/todo-comments.nvim',
            after = { 'trouble.nvim' },
            config = function()
                require('config.todo-comments').setup()
            end,
        }

        -- Git
        use { 'tpope/vim-fugitive' }
        use {
            'lewis6991/gitsigns.nvim',
            requires = { { 'nvim-lua/plenary.nvim' } },
            config = function()
                require('config.gitsigns').setup()
            end,
        }

        -- Lsp
        use {
            'neovim/nvim-lspconfig',
            requires = {
                { 'nvim-lua/lsp_extensions.nvim' },
                { 'nvim-lua/lsp-status.nvim' },
            },
            config = function()
                require('config.lsp').setup()
            end,
        }

        -- Debugging
        use {
            'mfussenegger/nvim-dap',
            config = function()
                require('config.dap').setup()
            end,
        }
        use {
            'rcarriga/nvim-dap-ui',
            after = { 'nvim-dap' },
            config = function()
                require('config.dap.ui').setup()
            end,
        }

        -- Completion
        use {
            'hrsh7th/nvim-cmp',
            requires = {
                { 'hrsh7th/cmp-path' },
                { 'hrsh7th/cmp-buffer' },
                { 'hrsh7th/cmp-nvim-lua' },
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'saadparwaiz1/cmp_luasnip' },
                { 'L3MON4D3/LuaSnip' },
            },
            config = function()
                require('config.cmp').setup()
            end,
        }
        -- Snippets
        use {
            'L3MON4D3/LuaSnip',
            config = function()
                require('config.luasnip').setup()
            end
        }

        -- Treesitter
        use {
            'nvim-treesitter/nvim-treesitter',
            run = function()
                vim.cmd(':TSUpdate')
            end,
            config = function()
                require('config.treesitter').setup()
            end,
        }
        use {
            'nvim-treesitter/playground',
            requires = { 'nvim-treesitter' },
            cmd = "TSPlaygroundToggle",
        }
        use {
            'romgrk/nvim-treesitter-context',
            requires = { 'nvim-treesitter' },
        }

        -- Markdown
        use {
            'plasticboy/vim-markdown',
            ft = { "markdown" },
            config = function()
                require('config.lang.markdown').setup()
            end,
        }
        use {
            'iamcco/markdown-preview.nvim',
            ft = { "markdown" },
            run = function()
                vim.call('mkdp#util#install')
            end,
        }
        use {
            'dhruvasagar/vim-table-mode',
            ft = { "markdown" },
        }

        -- Rust
        use {
            'rust-lang/rust.vim',
            ft = { "rust" },
            config = function()
                require('config.lang.rust').setup()
            end,
        }
        use {
            'saecki/crates.nvim',
            event = { "BufRead Cargo.toml" },
            requires = { { 'nvim-lua/plenary.nvim' } },
            config = function()
                require('config.crates').setup()
            end,
        }

        -- Lua/Teal
        use {
            'teal-language/vim-teal',
            ft = { "teal" },
        }

        -- Miscellaneous
        use { 'farmergreg/vim-lastplace' }

        -- Discord rich presence
        use { 'andweeb/presence.nvim' }

        -- Browser Integration
        use {
            'glacambre/firenvim',
            run = function()
                vim.call('firenvim#install', 0)
            end,
            config = function()
                require('config.firenvim').setup()
            end
        }
    end)
end

return M
