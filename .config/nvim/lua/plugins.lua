local M = {}

local mini_package_path = vim.fn.stdpath("data") .. "/site/"
local mini_package_start_path = mini_package_path .. "pack/deps/start/"
local mini_deps_path = mini_package_start_path .. "mini.deps"

local native_notify = vim.notify

local function print_info(pattern, ...)
    native_notify(string.format(pattern, ...), vim.log.levels.INFO)
    vim.cmd.redraw()
end

local function print_error(pattern, ...)
    native_notify(string.format(pattern, ...), vim.log.levels.ERROR)
    vim.cmd.redraw()
end

local function rmdir(dir)
    local ok, err = vim.uv.fs_rmdir(dir)
    if ok then
        print_info("removed dir `%s`", dir)
    else
        print_error("error removing dir `%s`: %s", dir, err)
        error()
    end
end

local function unlink(path, prev_link)
    local ok, err = vim.uv.fs_unlink(path)
    if ok then
        print_info("unlinked `%s` -> `%s`", path, prev_link)
    else
        print_error("error unlinking `%s` -> `%s`: %s", path, prev_link, err)
        error()
    end
end

local function symlink(link, link_target)
    local ok, err = vim.uv.fs_symlink(link_target, link, { dir = true })
    if ok then
        print_info("created symlink `%s` -> `%s`", link, link_target)
    else
        print_error("error creating symlink from `%s` -> `%s`: %s", link, link_target, err)
        error()
    end
end

---@param command string[]
---@param cwd string?
local function run_command(command, cwd)
    local command_str = table.concat(command, " ")
    print_info("running `%s`", command_str)
    vim.cmd.redraw()

    local res = nil
    local timeout = 30000
    local opts = {
        timeout = timeout,
        cwd = cwd,
    }
    vim.system(command, opts, function(r)
        res = r
    end)
    vim.wait(timeout, function()
        return res ~= nil
    end, 100)

    if res and res.code == 0 then
        print_info("success `%s`", command_str)
    else
        print_error("error running `%s`: `%s`", command_str, res.stderr)
        error()
    end
end

---@param spec table|string
---@return string
local function dev_repo(spec)
    if type(spec) == "string" then
        spec = { source = spec }
    end
    repo_url = "git@github.com:" .. spec.source

    local last_component = string.match(repo_url, "/?([^/]+)$")
    local project_path = vim.fn.expand("~/Projects/" .. last_component)
    local package_path = mini_package_path .. "pack/deps/opt/" .. last_component

    local function ensure_installed()
        if not vim.uv.fs_stat(project_path) then
            run_command({ "git", "clone", "--quiet", repo_url, project_path })
            if spec.checkout then
                run_command({ "git", "checkout", "--quiet", spec.checkout }, project_path)
            end
        end

        if vim.uv.fs_stat(package_path) then
            local link_path = vim.uv.fs_readlink(package_path)
            if link_path == project_path then
                -- correct symlink already exists
            elseif link_path then
                -- incorrect symlink
                unlink(package_path, project_path)
                symlink(package_path, project_path)
            else
                -- dir instead of symlink
                rmdir(package_path)
                symlink(package_path, project_path)
            end
        else
            symlink(package_path, project_path)
        end
    end
    pcall(ensure_installed)

    return "file://" .. project_path
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
        print_info("installing `mini.deps`")
        local clone_cmd = {
            "git", "clone", "--filter=blob:none",
            "https://github.com/echasnovski/mini.deps", mini_deps_path
        }
        vim.fn.system(clone_cmd)
        vim.cmd("packadd mini.deps | helptags ALL")
        print_info("installed `mini.deps`")
    end

    local mini_deps = require('mini.deps')
    mini_deps.setup({
        path = {
            package = mini_package_path,
            snapshot = vim.fn.stdpath("config") .. "/mini-deps.lock",
        },
    })

    local setup_queue = {}

    ---@param name string?
    ---@param spec table|string
    local function add(name, spec)
        if type(spec) == "string" then
            spec = { source = spec }
        end
        mini_deps.add(spec)

        if name then
            table.insert(setup_queue, "config." .. name)
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
            dev_repo("saecki/live-rename.nvim"),
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
    add("treesitter", {
        source = "nvim-treesitter/nvim-treesitter",
        hooks = {
            post_checkout = function()
                vim.cmd.TSUpdate()
            end,
        },
    })
    add(nil, dev_repo({ source = "saecki/nvim-treesitter-context", checkout = "categories" }))
    add(nil, "nvim-treesitter/nvim-treesitter-textobjects")
    add(nil, "yorickpeterse/nvim-tree-pairs")

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
    add("crates", dev_repo("saecki/crates.nvim"))

    -- lua/teal
    add(nil, "teal-language/vim-teal")

    -- typst
    add(nil, "kaarmu/typst.vim")

    -- discord rich presence
    vim.g.presence_has_setup = 1
    add("presence", "andweeb/presence.nvim")

    -- run all queued setups
    for _, name in ipairs(setup_queue) do
        require(name).setup()
    end

    -- some language specific things
    require("config.lang.zig").setup()
    require("config.lang.rust").setup()
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
