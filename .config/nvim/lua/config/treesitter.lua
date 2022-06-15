local M = {}

local wk = require("which-key")

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

    require("treesitter-context").setup({
        mode = "topline",
        truncate_side = "outer",
        max_lines = 2,
    })

    wk.register({
        ["<leader>et"] = { ":TSPlaygroundToggle<cr>", "Treesitter playground" },
    })
end

return M
