local M = {}

local mini_package_path = vim.fn.stdpath("data") .. "/site/"
local mini_package_start_path = mini_package_path .. "pack/deps/start/"
local mini_deps_path = mini_package_start_path .. "mini.deps"

local function create_symlink(dir_path)
    dir_path = vim.fn.expand(dir_path)
    local last_component = string.match(dir_path, "(/?[^/]+)$")
    local package_path = mini_package_path .. "opt/" .. last_component
    if not vim.uv.fs_stat(package_path) then
        local symlink_created = false
        local res = vim.uv.fs_symlink(dir_path, package_path, { dir = true }, function()
            symlink_created = true
        end)

        vim.wait(100, function()
            return symlink_created
        end, 1)

        vim.notify(string.format("created symlink: `%s` to `%s`", dir_path, package_path))
    end
end

---@param dir_path string
---@return string
local function local_dir(dir_path)
    create_symlink(dir_path)
    return "file://" .. vim.fn.expand(dir_path)
end

---@param name string?
---@param keys string[]
local function setup_on_keys(name, keys)
    local loaded = false
    local function load_and_feedkeys(key)
        return function()
            if loaded then
                return
            end
            loaded = true

            -- delete lazy loading keymaps
            for _, lhs in ipairs(keys) do
                vim.keymap.del("n", lhs)
            end

            require("config." .. name).setup()

            local feed = vim.api.nvim_replace_termcodes("<ignore>" .. key, true, true, true)
            vim.api.nvim_feedkeys(feed, "i", false)
        end
    end

    for _, lhs in ipairs(keys) do
        vim.keymap.set("n", lhs, load_and_feedkeys(lhs), {})
    end
end

function M.setup()
    -- bootstrap mini.deps
    if not vim.uv.fs_stat(mini_deps_path) then
        vim.cmd("echo 'installing `mini.deps`' | redraw")
        local clone_cmd = {
            "git", "clone", "--filter=blob:none",
            "https://github.com/echasnovski/mini.deps", mini_deps_path
        }
        vim.fn.system(clone_cmd)
        vim.cmd("packadd mini.deps | helptags ALL")
        vim.notify("echo 'installed `mini.deps`' | redraw")
    end

    local mini_deps = require('mini.deps')
    mini_deps.setup({
        path = {
            package = mini_package_path,
            snapshot = vim.fn.stdpath("config") .. "/mini-deps.lock",
        },
    })

    ---@param name string?
    ---@param spec table|string
    local function add(name, spec)
        if type(spec) == "string" then
            spec = { source = spec }
        end
        mini_deps.add(spec)

        if name then
            require("config." .. name).setup()
        end
    end

    -- key mappings
    add("which-key", "folke/which-key.nvim")

    -- load nvim-notify first so errors are pretty
    add("notify", "rcarriga/nvim-notify")

    -- gui enhancements
    add("lualine", {
        source = "nvim-lualine/lualine.nvim",
        depends = {
            "smoka7/multicursors.nvim",
            "smoka7/hydra.nvim",
        },
    })
    add("mini_hipatterns", "echasnovski/mini.hipatterns")
    add("indent-blankline", "lukas-reineke/indent-blankline.nvim")
    add("devicons", "nvim-tree/nvim-web-devicons")

    -- multicursor
    add("multicursors", {
        source = "smoka7/multicursors.nvim",
        depends = { "smoka7/hydra.nvim" },
    })

    -- filetree
    add(nil, {
        source = "kyazdani42/nvim-tree.lua",
        depends = { "nvim-tree/nvim-web-devicons" },
    })
    setup_on_keys("nvim-tree", { "<leader>x", "<leader>X" })

    -- file search/replace
    add("spectre", {
        source = "nvim-pack/nvim-spectre",
        depends = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
    })

    -- substitute
    add("substitute", "gbprod/substitute.nvim")

    -- file navigation
    add(nil, "farmergreg/vim-lastplace")
    add("telescope", {
        source = "nvim-telescope/telescope.nvim",
        depends = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
    })

    -- lists
    add("trouble", {
        source = "folke/trouble.nvim",
        depends = { "folke/todo-comments.nvim" },
    })

    -- completion
    add("cmp", {
        source = "hrsh7th/nvim-cmp",
        depends = {
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
    })

    -- snippets
    add("luasnip", "L3MON4D3/LuaSnip")

    -- git
    add("fugitive", "tpope/vim-fugitive")
    add("gitsigns", "lewis6991/gitsigns.nvim")

    -- lsp
    add("lsp", {
        source = "neovim/nvim-lspconfig",
        depends = {
            local_dir("~/Projects/live-rename.nvim"),
            "williamboman/mason.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "folke/trouble.nvim",
        },
    })

    -- debugging
    add("dap", {
        source = "mfussenegger/nvim-dap",
        depends = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio"
        },
    })

    -- treesitter
    add(nil, {
        source = "nvim-treesitter/nvim-treesitter",
        hooks = {
            post_checkout = function()
                vim.cmd.TSUpdate()
            end,
        },
    })
    add(nil, local_dir("~/Projects/nvim-treesitter-context"))
    add(nil, "nvim-treesitter/nvim-treesitter-textobjects")
    add(nil, "yorickpeterse/nvim-tree-pairs")
    require("config.treesitter").setup()

    -- markdown
    add(nil, {
        source = "iamcco/markdown-preview.nvim",
        hooks = {
            post_checkout = function()
                vim.call("mkdp#util#install")
            end
        },
    })
    add("markview", "OXY2DEV/markview.nvim")

    vim.g.table_mode_toggle_map = "e"
    vim.g.table_mode_tableize_d_map = "<leader>tT"
    add("table-mode", "dhruvasagar/vim-table-mode")

    -- rust
    add("crates", local_dir("~/Projects/crates.nvim"))

    -- lua/teal
    add(nil, "teal-language/vim-teal")

    -- typst
    add(nil, "kaarmu/typst.vim")

    -- discord rich presence
    vim.g.presence_has_setup = 1
    add("presence", "andweeb/presence.nvim")


    -- zig.vim is installed by the system package manager on fedora
    require("config.lang.zig").setup()

    -- some rust things
    require("config.lang.rust").setup()

    -- some lua things
    require("config.lang.lua").setup()


    local wk = require("which-key.config")
    wk.add({
        { "<leader>p",  group = "Plugins" },
        { "<leader>pu", mini_deps.update,        desc = "Update" },
        { "<leader>ps", "<cmd>DepsSnapSave<cr>", desc = "Save snapshot" },
        { "<leader>pr", "<cmd>DepsSnapLoad<cr>", desc = "Restore snapshot" },
        { "<leader>pl", "<cmd>DepsShowLog<cr>",  desc = "Log" },
    })
end

return M
