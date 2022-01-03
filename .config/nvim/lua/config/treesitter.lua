local M = {}

function M.setup()
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

    require("nvim-treesitter.configs").setup({
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
            "toml",
            "vim",
            "yaml",
            "zig",
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    })

    require("treesitter-context").setup({
        throttle = true,
        max_lines = 1,
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            default = {
                "class",
                "function",
                "method",
            },
        },
    })
end

return M
