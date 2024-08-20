local pm = require("plugman")

local M = {}

function M.setup()
    pm.create_dirs()

    -- key mappings
    pm.add("which-key", "folke/which-key.nvim")

    -- load nvim-notify first so errors are pretty
    pm.add("notify", "rcarriga/nvim-notify")

    -- gui enhancements
    pm.add("lualine", "nvim-lualine/lualine.nvim")
    pm.add("mini_hipatterns", "echasnovski/mini.hipatterns")
    pm.add("indent-blankline", "lukas-reineke/indent-blankline.nvim")
    pm.add("devicons", "nvim-tree/nvim-web-devicons")

    -- multicursor
    pm.add(nil, "mg979/vim-visual-multi")

    -- filetree
    pm.add(nil, {
        source = "kyazdani42/nvim-tree.lua",
        deps = { "nvim-tree/nvim-web-devicons" },
    })
    pm.setup_on_keys("nvim-tree", { "<leader>x", "<leader>X" })

    -- file search/replace
    pm.add("spectre", {
        source = "nvim-pack/nvim-spectre",
        deps = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
    })

    -- substitute
    pm.add("substitute", "gbprod/substitute.nvim")

    -- file navigation
    pm.add(nil, "farmergreg/vim-lastplace")
    pm.add("telescope", {
        source = "nvim-telescope/telescope.nvim",
        deps = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
    })

    -- lists
    pm.add("trouble", {
        source = "folke/trouble.nvim",
        deps = { "folke/todo-comments.nvim" },
    })

    -- completion
    pm.add("cmp", {
        source = "hrsh7th/nvim-cmp",
        deps = {
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
    })

    -- snippets
    pm.add("luasnip", "L3MON4D3/LuaSnip")

    -- git
    pm.add("fugitive", "tpope/vim-fugitive")
    pm.add("gitsigns", "lewis6991/gitsigns.nvim")

    -- lsp
    pm.dev_repo(nil, "saecki/live-rename.nvim")
    pm.add("lsp", {
        source = "neovim/nvim-lspconfig",
        deps = {
            "williamboman/mason.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "folke/trouble.nvim",
        },
    })

    -- debugging
    pm.add("dap", {
        source = "mfussenegger/nvim-dap",
        deps = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio"
        },
    })

    -- treesitter
    pm.add("treesitter", {
        source = "nvim-treesitter/nvim-treesitter",
        post_checkout = function()
            vim.cmd.TSUpdate()
        end,
    })
    pm.dev_repo(nil, { source = "saecki/nvim-treesitter-context", checkout = "categories" })
    pm.add(nil, "nvim-treesitter/nvim-treesitter-textobjects")
    pm.add(nil, "yorickpeterse/nvim-tree-pairs")

    -- markdown
    pm.add(nil, {
        source = "iamcco/markdown-preview.nvim",
        post_checkout = function()
            vim.call("mkdp#util#install")
        end
    })
    pm.add("markview", "OXY2DEV/markview.nvim")

    vim.g.table_mode_toggle_map = "e"
    vim.g.table_mode_tableize_d_map = "<leader>tT"
    pm.add("table-mode", "dhruvasagar/vim-table-mode")

    -- rust
    pm.dev_repo("crates", "saecki/crates.nvim")

    -- lua/teal
    pm.add(nil, "teal-language/vim-teal")

    -- typst
    pm.add(nil, "kaarmu/typst.vim")

    -- discord rich presence
    vim.g.presence_has_setup = 1
    pm.add("presence", "andweeb/presence.nvim")

    -- run all queued setups
    pm.run_queued_setups()

    -- some language specific things
    require("config.lang.zig").setup()
    require("config.lang.rust").setup()
    require("config.lang.lua").setup()

    local wk = require("which-key.config")
    -- TODO: implement update
    -- TODO: automatically store a lock file
    -- TODO: allow restoring to a lock file
    -- wk.add({
    --     { "<leader>p",  group = "Plugins" },
    --     { "<leader>pu", pm.update,  desc = "Update"  },
    --     { "<leader>pr", pm.restore, desc = "Restore" },
    --     { "<leader>pl", pm.log,     desc = "Log"     },
    -- })
end

return M
