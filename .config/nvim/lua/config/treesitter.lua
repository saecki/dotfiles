local function setup()
    require'nvim-treesitter.configs'.setup {
        ensure_installed = {
            "bash",
            "c",
            "cpp",
            "css",
            "dart",
            "dockerfile",
            "go",
            "java",
            "json",
            "kotlin",
            "latex",
            "lua",
            "python",
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
