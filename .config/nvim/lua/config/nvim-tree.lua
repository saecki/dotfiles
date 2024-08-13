local nvim_tree = require("nvim-tree")
local api = require("nvim-tree.api")
local wk = require("which-key.config")

local M = {}

function M.setup()
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
            wk.add({
                buffer = buf,

                { "<cr>",           api.node.open.edit,                 desc = "Open" },
                { "o",              api.node.open.edit,                 desc = "Open" },
                { "<2-leftmouse>",  api.node.open.edit,                 desc = "Open" },
                { "<2-rightmouse>", api.tree.change_root_to_node,       desc = "cd" },
                { "<c-]>",          api.tree.change_root_to_node,       desc = "cd" },
                { "<c-v>",          api.node.open.vertical,             desc = "Open vertical split" },
                { "<c-x>",          api.node.open.horizontal,           desc = "Open horizontal split" },
                { "<c-t>",          api.node.open.tab,                  desc = "Open in new tab" },
                { "<",              api.node.navigate.sibling.prev,     desc = "Next sibling" },
                { ">",              api.node.navigate.sibling.next,     desc = "Previous sibling" },
                { "K",              api.node.navigate.sibling.first,    desc = "First sibling" },
                { "J",              api.node.navigate.sibling.last,     desc = "Last sibling" },
                { "P",              api.node.navigate.parent,           desc = "Parent directory" },
                { "-",              api.node.navigate.parent,           desc = "Parent directory" },
                { "<bs>",           api.node.navigate.parent_close,     desc = "Close directory" },
                { "I",              api.tree.toggle_gitignore_filter,   desc = "Toggle gitignore" },
                { "<c-h>",          api.tree.toggle_hidden_filter,      desc = "Toggle hidden files" },
                { "<c-r>",          api.tree.reload,                    desc = "Refresh" },
                { "a",              api.fs.create,                      desc = "Create" },
                { "d",              api.fs.remove,                      desc = "Remove" },
                { "r",              api.fs.rename_basename,             desc = "Rename file stem" },
                { "R",              api.fs.rename,                      desc = "Rename filename" },
                { "x",              api.fs.cut,                         desc = "Cut file" },
                { "p",              api.fs.paste,                       desc = "Paste file" },
                { "c",              api.fs.copy.node,                   desc = "Copy file" },
                { "y",              api.fs.copy.filename,               desc = "Copy filename" },
                { "Y",              api.fs.copy.relative_path,          desc = "Copy relative path" },
                { "gy",             api.fs.copy.absolute_path,          desc = "Copy absolute path" },
                { "[d",             api.node.navigate.diagnostics.prev, desc = "Next diagnsotic" },
                { "]d",             api.node.navigate.diagnostics.next, desc = "Previous diagnsotic" },
                { "[g",             api.node.navigate.git.prev,         desc = "Next git item" },
                { "]g",             api.node.navigate.git.next,         desc = "Previous git item" },
                { "s",              api.node.run.system,                desc = "Open system" },
                { "q",              api.tree.close,                     desc = "Close" },
                { "g?",             api.toggle_help,                    desc = "Toggle help" },
            })
        end
    }

    wk.add({
        { "<leader>x", api.tree.toggle, desc = "Filetree toggle" },
        {
            "<leader>X",
            function()
                api.tree.toggle({ find_file = true })
            end,
            desc = "Filetree current file",
        },
    })
end

return M
