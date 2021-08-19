local function setup()
    require'nvim-treesitter.configs'.setup {
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
            "java",
            "json",
            "kotlin",
            "latex",
            "lua",
            "python",
            "query",
            "regex",
            "rust",
            "toml",
            "yaml",
            "zig",
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    }

    require('treesitter-context').setup {
        enable = false,
        throttle = true,
    }
end

return {
    setup = setup
}
