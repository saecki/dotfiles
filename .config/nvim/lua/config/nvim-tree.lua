local M = {}

local nvim_tree = require("nvim-tree")
local api = require("nvim-tree.api")
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
        },
        on_attach = function(buf)
            wk.register({
                ["<cr>"]           = { api.node.open.edit, "Open" },
                ["o"]              = { api.node.open.edit, "Open" },
                ["<2-leftmouse>"]  = { api.node.open.edit, "Open" },
                ["<2-rightmouse>"] = { api.tree.change_root_to_node, "cd" },
                ["<c-]>"]          = { api.tree.change_root_to_node, "cd" },
                ["<c-v>"]          = { api.node.open.vertical, "Open vertical split" },
                ["<c-x>"]          = { api.node.open.horizontal, "Open horizontal split" },
                ["<c-t>"]          = { api.node.open.tab, "Open in new tab" },
                ["<"]              = { api.node.navigate.sibling.prev, "Next sibling" },
                [">"]              = { api.node.navigate.sibling.next, "Prev sibling" },
                ["K"]              = { api.node.navigate.sibling.first, "First sibling" },
                ["J"]              = { api.node.navigate.sibling.last, "Last sibling" },
                ["P"]              = { api.node.navigate.parent, "Parent directory" },
                ["-"]              = { api.node.navigate.parent, "Parent directory" },
                ["<bs>"]           = { api.node.navigate.parent_close, "Close directory" },
                ["I"]              = { api.tree.toggle_gitignore_filter, "Toggle gitignore" },
                ["<c-h>"]          = { api.tree.toggle_hidden_filter, "Toggle hidden files" },
                ["<c-r>"]          = { api.tree.reload, "Refresh" },
                ["a"]              = { api.fs.create, "Create" },
                ["d"]              = { api.fs.remove, "Remove" },
                ["r"]              = { api.fs.rename_basename, "Rename file stem" },
                ["R"]              = { api.fs.rename, "Rename filename" },
                ["x"]              = { api.fs.cut, "Cut file" },
                ["p"]              = { api.fs.paste, "Paste file" },
                ["c"]              = { api.fs.copy.node, "Copy file" },
                ["y"]              = { api.fs.copy.filename, "Copy filename" },
                ["Y"]              = { api.fs.copy.relative_path, "Copy relative path" },
                ["gy"]             = { api.fs.copy.absolute_path, "Copy absolute path" },
                ["g["]             = { api.node.navigate.diagnostics.prev, "Next diagnsotic" },
                ["g]"]             = { api.node.navigate.diagnostics.next, "Prev diagnsotic" },
                ["g{"]             = { api.node.navigate.git.prev, "Next git item" },
                ["g}"]             = { api.node.navigate.git.next, "Prev git item" },
                ["s"]              = { api.node.run.system, "Open system" },
                ["q"]              = { api.tree.close, "Close" },
                ["g?"]             = { api.toggle_help, "Toggle help" },
            }, {
                buffer = buf,
            })
        end
    }
    -- stylua: ignore end

    wk.register({
        ["<leader>x"] = { api.tree.toggle, "Filetree toggle" },
        ["<leader>X"] = {
            function()
                api.tree.toggle({ find_file = true })
            end,
            "Filetree current file",
        },
    })
end

return M
