local ts = require("nvim-treesitter")
local ts_textobjects = require("nvim-treesitter-textobjects")

local ts_parsers = require("nvim-treesitter.parsers")
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

    -- Install parsers
    ts.install({
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
    })

    -- Custom parsers
    do
        local repo_path = vim.fn.expand("~/Projects/tree-sitter-vvm")
        vim.opt.rtp:append(repo_path)
        ts_parsers.vvm = {
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

    -- Highlighting
    local group = vim.api.nvim_create_augroup("user.config.treesitter", {})
    vim.api.nvim_create_autocmd('FileType', {
        group = group,
        callback = function(ev)
            pcall(vim.treesitter.start, ev.buf)
        end,
    })

    -- Indenting
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

    -- TODO: Migrate configuration
    -- Text objects
    ts_textobjects.setup({
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
                -- Jump between diff chunks instead.
                -- ["]c"] = make_mapping("Next", "@class.outer"),
            },
            goto_previous_start = {
                ["[a"] = make_mapping("Previous", "@parameter.inner"),
                ["[f"] = make_mapping("Previous", "@function.outer"),
                -- Jump between diff chunks instead.
                -- ["[c"] = make_mapping("Previous", "@class.outer"),
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
    })

    -- TODO: Update fork
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
