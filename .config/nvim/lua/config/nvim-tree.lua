local M = {}

local wk = require("which-key")
local util = require("util")

function M.setup()
    vim.g.nvim_tree_git_hl = 1
    vim.g.nvim_tree_show_icons = {
        folder_arrows = 1,
        folders = 1,
        files = 1,
        git = 1,
    }
    vim.g.nvim_tree_special_files = {}
    vim.g.nvim_tree_icons = {
        default = "",
        symlink = "",
        git = {
            unstaged = "",
            staged = "",
            unmerged = "",
            renamed = "",
            untracked = "",
            deleted = "",
            ignored = "~",
        },
        folder = {
            arrow_closed = "",
            arrow_open = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
        },
    }

    local nvim_tree = require("nvim-tree")
    local tree_cb = require("nvim-tree.config").nvim_tree_callback

    -- stylua: ignore start
    nvim_tree.setup {
        diagnostics = {
            enable = true,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            },
        },
        view = {
            width = 40,
            auto_resize = true,
            mappings = {
                list = {
                    { key = { "<cr>", "o", "<2-leftmouse>" },   cb = tree_cb("edit") },
                    { key = { "<2-rightmouse>", "<C-]>", "$" }, cb = tree_cb("cd") },
                    { key = "<c-v>",                            cb = tree_cb("vsplit") },
                    { key = "<c-x>",                            cb = tree_cb("split") },
                    { key = "<c-t>",                            cb = tree_cb("tabnew") },
                    { key = "<",                                cb = tree_cb("prev_sibling") },
                    { key = ">",                                cb = tree_cb("next_sibling") },
                    { key = "P",                                cb = tree_cb("parent_node") },
                    { key = "<bs>",                             cb = tree_cb("close_node") },
                    { key = "<s-cr>",                           cb = tree_cb("close_node") },
                    { key = "<tab>",                            cb = tree_cb("preview") },
                    { key = "K",                                cb = tree_cb("first_sibling") },
                    { key = "J",                                cb = tree_cb("last_sibling") },
                    { key = "I",                                cb = tree_cb("toggle_ignored") },
                    { key = "<c-h>",                            cb = tree_cb("toggle_dotfiles") },
                    { key = "<c-r>",                            cb = tree_cb("refresh") },
                    { key = "a",                                cb = tree_cb("create") },
                    { key = "d",                                cb = tree_cb("remove") },
                    { key = "r",                                cb = tree_cb("rename") },
                    { key = "R",                                cb = tree_cb("full_rename") },
                    { key = "x",                                cb = tree_cb("cut") },
                    { key = "c",                                cb = tree_cb("copy") },
                    { key = "p",                                cb = tree_cb("paste") },
                    { key = "y",                                cb = tree_cb("copy_name") },
                    { key = "Y",                                cb = tree_cb("copy_path") },
                    { key = "gy",                               cb = tree_cb("copy_absolute_path") },
                    { key = "g{",                               cb = tree_cb("prev_git_item") },
                    { key = "g}",                               cb = tree_cb("next_git_item") },
                    { key = "-",                                cb = tree_cb("dir_up") },
                    { key = "s",                                cb = tree_cb("system_open") },
                    { key = "q",                                cb = tree_cb("close") },
                    { key = "g?",                               cb = tree_cb("toggle_help") },
                },
            },
        },
    }
    -- stylua: ignore end

    wk.register({
        ["<f6>"] = { nvim_tree.toggle, "Filetree toggle" },
        ["<f18>"] = { util.wrap(nvim_tree.toggle, true), "Filetree current file" },
    })
end

return M
