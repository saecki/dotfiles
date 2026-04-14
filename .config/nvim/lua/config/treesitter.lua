local ts = require("nvim-treesitter")
local ts_textobjects = require("nvim-treesitter-textobjects")
local ts_textobjects_select = require("nvim-treesitter-textobjects.select")
local ts_textobjects_move = require("nvim-treesitter-textobjects.move")
local ts_textobjects_swap = require("nvim-treesitter-textobjects.swap")


local ts_parsers = require("nvim-treesitter.parsers")
local ts_context = require("treesitter-context")
local ts_pairs = require("tree-pairs")
local wk = require("which-key.config")

local M = {}

---@param lhs string
---@param textobject string
local function map_selection(lhs, textobject)
    vim.keymap.set(
        { "x", "o" }, lhs,
        function()
            ts_textobjects_select.select_textobject(textobject, "textobjects")
        end,
        { desc = textobject }
    )
end

---@param lhs string
---@param textobject string
local function map_move(lhs, textobject)
    vim.keymap.set(
        { "n", "x", "o" }, "[" .. lhs,
        function()
            ts_textobjects_move.goto_prev_start(textobject, "textobjects")
        end,
        { desc = "Previous " .. textobject }
    )
    vim.keymap.set(
        { "n", "x", "o" }, "]" .. lhs,
        function()
            ts_textobjects_move.goto_next_start(textobject, "textobjects")
        end,
        { desc = "Next " .. textobject }
    )
end

---@param lhs string
---@param textobject string
local function map_swap(lhs, textobject)
    -- keymaps
    vim.keymap.set(
        "n", "<a-backspace><a-" .. lhs .. ">",
        function()
            ts_textobjects_swap.swap_previous(textobject)
        end,
        { desc = "Swap previous " .. textobject }
    )
    vim.keymap.set(
        "n", "<a-space><a-" .. lhs .. ">",
        function()
            ts_textobjects_swap.swap_next(textobject)
        end,
        { desc = "Swap next " .. textobject }
    )
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

    -- Text objects
    ts_textobjects.setup({
        select = {
            lookahead = true,
        },
        move = {
            set_jumps = true,
        },
    })

    map_selection("ia", "@parameter.inner")
    map_selection("aa", "@parameter.outer")
    map_selection("if", "@function.inner")
    map_selection("af", "@function.outer")
    map_selection("ic", "@class.inner")
    map_selection("ac", "@class.outer")

    map_move("a", "@parameter.inner")
    map_move("f", "@function.outer")

    map_swap("a", "@parameter.inner")
    map_swap("f", "@function.outer")

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
