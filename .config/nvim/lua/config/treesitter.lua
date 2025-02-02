local ts_config = require("nvim-treesitter.configs")
local ts_parser = require("nvim-treesitter.parsers")
local ts_context = require("treesitter-context")
local ts_pairs = require("tree-pairs")
local wk = require("which-key.config")

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

local function jump_to_context()
    ts_context.go_to_context(vim.v.count1)
    vim.cmd.normal({ args = { "zt" }, bang = true })
end

function M.setup()
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

    do
        local repo_path = vim.fn.expand("~/Projects/tree-sitter-vvm")
        vim.opt.rtp:append(repo_path)
        local parser_config = ts_parser.get_parser_configs()
        parser_config.vvm = {
            install_info = {
                url = repo_path,
                files = {
                    "src/parser.c",
                    "src/scanner.c",
                },
                generate_requires_npm = false,
                requires_generate_from_grammar = false,
            },
            filetype = "vvm",
        }
    end

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
            -- "dart",
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
            "jsonc",
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
                    ["<a-space><a-a>"] = "@parameter.inner",
                    ["<a-space><a-f>"] = "@function.outer",
                    ["<a-space><a-e>"] = "@element",
                },
                swap_previous = {
                    ["<a-backspace><a-a>"] = "@parameter.inner",
                    ["<a-backspace><a-f>"] = "@function.outer",
                    ["<a-backspace><a-e>"] = "@element",
                },
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

    ts_pairs.setup()

    wk.add({
        -- somewhat similar to `z<cr>`
        { "g<cr>", jump_to_context, desc = "Jump to context" },
    })
end

return M
