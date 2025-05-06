local pm = require("plugman")

local M = {}

function M.setup()
    pm.start_setup()

    -- key mappings
    pm.add("which-key", "folke/which-key.nvim")

    -- load nvim-notify first so errors are pretty
    pm.add("notify", "rcarriga/nvim-notify")

    -- gui enhancements
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
    pm.setup_on_keys("nvim-tree", {
        { "<leader>x", desc = "Filetree toggle" },
        { "<leader>X", desc = "Filetree current file" },
    })
    pm.add("oil", "stevearc/oil.nvim")

    -- file search/replace
    pm.add("grug-far", {
        source = "MagicDuck/grug-far.nvim",
        deps = { "nvim-tree/nvim-web-devicons" },
    })

    -- file navigation
    pm.add(nil, "farmergreg/vim-lastplace")
    pm.add("harpoon", {
        source = "ThePrimeagen/harpoon",
        checkout = "harpoon2",
        deps = { "nvim-lua/plenary.nvim" },
    })
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

    -- snippets
    pm.add("luasnip", "L3MON4D3/LuaSnip")

    -- completion
    pm.add("blink", {
        source = "Saghen/blink.cmp",
        checkout = "v1.1.1",
    })

    -- git
    pm.add("fugitive", "tpope/vim-fugitive")
    pm.add("gitsigns", "lewis6991/gitsigns.nvim")

    -- lsp
    pm.dev_repo(nil, "saecki/live-rename.nvim")
    pm.add("lsp", {
        source = "neovim/nvim-lspconfig",
        deps = {
            "williamboman/mason.nvim",
            "Saghen/blink.cmp",
            "folke/trouble.nvim",
            "vxpm/ferris.nvim",
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

    -- text manipulation
    vim.g.table_mode_toggle_map = "e"
    vim.g.cable_mode_tableize_d_map = "<leader>tT"
    pm.add("table-mode", "dhruvasagar/vim-table-mode")
    pm.add("substitute", "gbprod/substitute.nvim")
    pm.add(nil, "tpope/vim-abolish")

    -- rust
    pm.dev_repo("crates", "saecki/crates.nvim")

    -- lua/teal
    pm.add(nil, "teal-language/vim-teal")

    -- typst
    vim.g.typst_auto_open_quickfix = 0
    pm.add(nil, "kaarmu/typst.vim")
    pm.dev_repo("typst-test-helper", "saecki/typst-test-helper.nvim")

    -- discord rich presence
    -- vim.g.presence_has_setup = 1
    -- pm.add("presence", "andweeb/presence.nvim")

    pm.finish_setup(function()
        local wk = require("which-key.config")
        wk.add({
            { "<leader>p",  group = "Plugins" },
            { "<leader>pf", pm.fetch,             desc = "Fetch" },
            { "<leader>pu", pm.update,            desc = "Update" },
            { "<leader>pU", pm.update_no_lock,    desc = "Update without writing lockfile" },
            { "<leader>ps", pm.save_lock_file,    desc = "Save lock" },
            { "<leader>pr", pm.restore_lock_file, desc = "Restore lock" },
            { "<leader>pl", pm.log,               desc = "Log" },
        })
    end)
end

return M
