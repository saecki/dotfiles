local M = {}

local ts_config = require("nvim-treesitter.configs")
local ts_context = require("treesitter-context")
local CATEGORY = ts_context.CATEGORY or {}
local wk = require("which-key")

function M.setup()
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

    ts_config.setup({
        ensure_installed = {
            "bash",
            "c",
            "cmake",
            "comment",
            "cpp",
            "css",
            "dart",
            "dockerfile",
            "fish",
            "go",
            "graphql",
            "haskell",
            "html",
            "java",
            "json",
            "kotlin",
            "latex",
            "lua",
            "markdown",
            "nix",
            "python",
            "query",
            "regex",
            "rust",
            "teal",
            "toml",
            "vim",
            "yaml",
            "zig",
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        playground = {
            enable = true,
        },
    })

    ts_context.setup({
        mode = "topline",
        truncate_side = "outer",
        max_lines = 2,
        categories = {
            ["if"] = false,
            ["switch"] = false,
            ["loop"] = false,
            ["lambda"] = false,
        },
    })

    wk.register({
        ["<leader>et"] = { ":TSPlaygroundToggle<cr>", "Treesitter playground" },
    })
end

return M
