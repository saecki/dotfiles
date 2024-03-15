local ts_config = require("nvim-treesitter.configs")
local ts_context = require("treesitter-context")
local wk = require("which-key")

local M = {}

---@param prefix string
---@param textobject string
---@return table
local function make_mapping(prefix, textobject)
    return {
        query = textobject,
        desc = string.format("%s %s", prefix, textobject),
    }
end

function M.setup()
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

    ts_config.setup({
        ensure_installed = {
            "asm",
            "awk",
            "bash",
            "bibtex",
            "c",
            "c_sharp",
            "cmake",
            "comment",
            "cpp",
            "css",
            "cuda",
            "dart",
            "diff",
            "dockerfile",
            "fish",
            "git_config",
            "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
            "glsl",
            "go",
            "graphql",
            "haskell",
            "hlsl",
            "html",
            "java",
            "json",
            "kotlin",
            "latex",
            "lua",
            "markdown",
            "matlab",
            "nim",
            "nix",
            "python",
            "query",
            "regex",
            "rust",
            "teal",
            "toml",
            "typst",
            "vim",
            "wgsl",
            "yaml",
            "zig",
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<c-space>",
                node_incremental = "<c-space>",
                scope_incremental = "<c-s>",
                node_decremental = "<c-backspace>",
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["ia"] = make_mapping("Textobject", "@parameter.inner"),
                    ["aa"] = make_mapping("Textobject", "@parameter.outer"),
                    ["if"] = make_mapping("Textobject", "@function.inner"),
                    ["af"] = make_mapping("Textobject", "@function.outer"),
                    ["ic"] = make_mapping("Textobject", "@class.inner"),
                    ["ac"] = make_mapping("Textobject", "@class.outer"),
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]a"] = make_mapping("Next", "@parameter.inner"),
                    ["]f"] = make_mapping("Next", "@function.outer"),
                    ["]c"] = make_mapping("Next", "@class.outer"),
                },
                goto_previous_start = {
                    ["[a"] = make_mapping("Previous", "@parameter.inner"),
                    ["[f"] = make_mapping("Previous", "@function.outer"),
                    ["[c"] = make_mapping("Previous", "@class.outer"),
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<m-space><m-a>"] = "@parameter.inner",
                    ["<m-space><m-f>"] = "@function.outer",
                    ["<m-space><m-e>"] = "@element",
                },
                swap_previous = {
                    ["<m-backspace><m-a>"] = "@parameter.inner",
                    ["<m-backspace><m-f>"] = "@function.outer",
                    ["<m-backspace><m-e>"] = "@element",
                },
            }
        },
        playground = {
            enable = true,
            keybindins = {
                toggle_query_editor = "o",
                toggle_highlight_groups = "i",
                toggle_injected_languages = "t",

                goto_node = "<cr>",
            }
        },
    })

    ts_context.setup({
        mode = "topline",
        truncate_side = "outer",
        max_lines = 2,
        categories = {
            default = {
                ["conditional"] = false,
                ["loop"] = false,
                ["block"] = false,
                ["assignment"] = false,
                ["invocation"] = false,
                ["closure"] = false,
            },
            lua = {
                ["table"] = false,
            },
        },
    })

    wk.register({
        ["<leader>et"] = { ":TSPlaygroundToggle<cr>", "Treesitter playground" },
        ["g%"] = { ts_context.go_to_context, "Jump to context" },
    })
end

return M
