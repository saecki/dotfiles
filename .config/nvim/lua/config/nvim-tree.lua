local M = {}

local nvim_tree = require("nvim-tree")
local wk = require("which-key")
local util = require("util")

function M.setup()
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
        renderer = {
            highlight_git = true,
            icons = {
                show = {
                    folder_arrow = true,
                    folder = true,
                    file = true,
                },
                glyphs = {
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
                },
            },
            special_files = {},
        },
        view = {
            width = 40,
            mappings = {
                list = {
                    { key = { "<cr>", "o", "<2-leftmouse>" },   action = "edit" },
                    { key = { "<2-rightmouse>", "<c-]>", "$" }, action = "cd" },
                    { key = "<c-v>",                            action = "vsplit" },
                    { key = "<c-x>",                            action = "split" },
                    { key = "<c-t>",                            action = "tabnew" },
                    { key = "<",                                action = "prev_sibling" },
                    { key = ">",                                action = "next_sibling" },
                    { key = "P",                                action = "parent_node" },
                    { key = "<bs>",                             action = "close_node" },
                    { key = "<s-cr>",                           action = "close_node" },
                    { key = "<tab>",                            action = "preview" },
                    { key = "K",                                action = "first_sibling" },
                    { key = "J",                                action = "last_sibling" },
                    { key = "I",                                action = "toggle_ignored" },
                    { key = "<c-h>",                            action = "toggle_dotfiles" },
                    { key = "<c-r>",                            action = "refresh" },
                    { key = "a",                                action = "create" },
                    { key = "d",                                action = "remove" },
                    { key = "r",                                action = "rename" },
                    { key = "R",                                action = "full_rename" },
                    { key = "x",                                action = "cut" },
                    { key = "c",                                action = "copy" },
                    { key = "p",                                action = "paste" },
                    { key = "y",                                action = "copy_name" },
                    { key = "Y",                                action = "copy_path" },
                    { key = "gy",                               action = "copy_absolute_path" },
                    { key = "g{",                               action = "prev_git_item" },
                    { key = "g}",                               action = "next_git_item" },
                    { key = "-",                                action = "dir_up" },
                    { key = "s",                                action = "system_open" },
                    { key = "q",                                action = "close" },
                    { key = "g?",                               action = "toggle_help" },
                },
            },
        },
    }
    -- stylua: ignore end

    wk.register({
        ["<leader>x"] = { nvim_tree.toggle, "Filetree toggle" },
        ["<leader>X"] = { util.wrap(nvim_tree.toggle, true), "Filetree current file" },
    })
end

return M
