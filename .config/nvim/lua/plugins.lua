local M = {}

local util = require("util")

---@param plugin string
---@return function
local function config(plugin)
    return function()
        require("config." .. plugin).setup()
    end
end

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

    -- vimscript things
    vim.g.table_mode_toggle_map = "e"
    vim.g.table_mode_tableize_d_map = "<leader>tT"

    vim.g.presence_has_setup = 1


    local lazy = require("lazy")
    lazy.setup({
        -- Key mappings
        {
            "folke/which-key.nvim",
            config = config("which-key"),
        },

        -- Gui enhancements
        {
            "rcarriga/nvim-notify",
            priority = 100,
            config = config("notify"),
        },
        {
            "nvim-lualine/lualine.nvim",
            -- for multicursors.nvim
            dependencies = { "smoka7/hydra.nvim" },
            config = config("lualine"),
        },
        {
            "echasnovski/mini.hipatterns",
            keys = {
                { "<leader>ec", desc = "Colorizer" },
                { "<leader>eC", desc = "Colorizer style" },
            },
            config = config("mini_hipatterns"),
        },
        {
            "lukas-reineke/indent-blankline.nvim",
            config = config("indent-blankline"),
        },
        {
            "nvim-tree/nvim-web-devicons",
            config = config("devicons"),
        },

        -- Multicursor
        {
            "smoka7/multicursors.nvim",
            dependencies = { "smoka7/hydra.nvim" },
            config = config("multicursors"),
        },

        -- Filetree
        {
            "kyazdani42/nvim-tree.lua",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            keys = { "<leader>x", "<leader>X" },
            config = config("nvim-tree"),
        },

        -- File Search/Replace
        {
            "nvim-pack/nvim-spectre",
            dependencies = {
                { "nvim-lua/plenary.nvim" },
                { "nvim-tree/nvim-web-devicons" },
            },
            config = config("spectre"),
        },

        -- File navigation
        "farmergreg/vim-lastplace",
        {
            "nvim-telescope/telescope.nvim",
            dependencies = {
                { "nvim-lua/plenary.nvim" },
                { "nvim-tree/nvim-web-devicons" },
            },
            config = config("telescope"),
        },
        {
            "ThePrimeagen/harpoon",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = config("harpoon"),
        },

        -- Lists
        {
            "folke/trouble.nvim",
            dependencies = { "folke/todo-comments.nvim" },
            config = config("trouble"),
        },

        -- Git
        {
            "tpope/vim-fugitive",
            config = config("fugitive"),
        },
        {
            "lewis6991/gitsigns.nvim",
            config = config("gitsigns"),
        },

        -- Lsp
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                { "williamboman/mason.nvim" },
                { "hrsh7th/cmp-nvim-lsp" },
                { "folke/trouble.nvim" },
            },
            config = config("lsp"),
        },
        {
            "j-hui/fidget.nvim",
            tag = "legacy",
            config = config("fidget"),
        },

        -- Debugging
        {
            "mfussenegger/nvim-dap",
            dependencies = {
                "rcarriga/nvim-dap-ui",
                "nvim-neotest/nvim-nio",
            },
            config = config("dap"),
        },

        -- Completion
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                { "hrsh7th/cmp-path" },
                { "hrsh7th/cmp-buffer" },
                { "hrsh7th/cmp-nvim-lsp" },
                { "saadparwaiz1/cmp_luasnip" },
                { "L3MON4D3/LuaSnip" },
            },
            config = config("cmp"),
        },

        -- Snippets
        {
            "L3MON4D3/LuaSnip",
            config = config("luasnip"),
        },

        -- Substitute
        {
            "gbprod/substitute.nvim",
            config = config("substitute"),
        },

        -- Treesitter
        {
            "nvim-treesitter/nvim-treesitter",
            dependencies = {
                { dir = "~/Projects/nvim-treesitter-context" },
                { "nvim-treesitter/playground" },
                { "nvim-treesitter/nvim-treesitter-textobjects" },
                { "yorickpeterse/nvim-tree-pairs" },
            },
            build = function()
                vim.cmd.TSUpdate()
            end,
            config = config("treesitter"),
        },

        -- Markdown
        {
            "iamcco/markdown-preview.nvim",
            ft = { "markdown" },
            build = function()
                vim.call("mkdp#util#install")
            end,
        },
        {
            "OXY2DEV/markview.nvim",
            ft = { "markdown" },
            branch = "dev",
            config = config("markview"),
        },
        {
            "dhruvasagar/vim-table-mode",
            config = config("table-mode"),
        },

        -- Rust
        {
            dir = "~/Projects/crates.nvim",
            dependencies = {
                -- for the attach function
                "neovim/nvim-lspconfig",
            },
            config = config("crates"),
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
            config = config("presence"),
        },
    })

    -- zig.vim is installed by the system package manager on fedora
    require("config.lang.zig").setup()

    -- some rust things
    require("config.lang.rust").setup()

    -- some lua things
    require("config.lang.lua").setup()

    local wk = require("which-key")
    wk.add({
        { "<leader>p", ":Lazy<cr>", desc = "Toggle Plugins UI" },
    })
end

return M
