local M = {}

local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local wk = require("which-key")

local function find_files(opts)
    return function()
        local fd_cmd = { "fd", "--type", "f", "--exclude", ".git", "--hidden" }
        telescope_builtin.find_files({
            find_command = fd_cmd,
            no_ignore = opts.no_ignore,
        })
    end
end

function M.setup()
    telescope.setup({
        defaults = {
            layout_config = {
                horizontal = {
                    width = {
                        padding = 8,
                    },
                    height = {
                        padding = 3,
                    },
                    preview_cutoff = 120,
                },
            },
            borderchars = {
                prompt = {
                    "█",
                    "█",
                    "█",
                    "█",
                    "█",
                    "█",
                    "",
                    "",
                },
                results = {
                    "█",
                    "█",
                    "█",
                    "█",
                    "",
                    "",
                    "█",
                    "█",
                },
                preview = {
                    "█",
                    "█",
                    "█",
                    "▐",
                    "▐",
                    "",
                    "",
                    "▐",
                },
            },
            prompt_prefix = " ",
            selection_caret = " ",
        },
    })

    wk.register({
        ["<leader>"] = {
            ["f"] = {
                name = "Find",
                ["p"] = { find_files({ no_ignore = false }), "Files" },
                ["P"] = { find_files({ no_ignore = true }), "Ignored Files" },
                ["f"] = { telescope_builtin.live_grep, "Live grep" },
                ["b"] = { telescope_builtin.buffers, "Buffers" },
                ["h"] = { telescope_builtin.help_tags, "Help" },
                ["c"] = { telescope_builtin.commands, "Commands" },
                ["m"] = { telescope_builtin.keymaps, "Key mappings" },
                ["i"] = { telescope_builtin.highlights, "Highlight groups" },
                ["g"] = { telescope_builtin.git_status, "Git status" },
                ["d"] = {
                    function()
                        telescope_builtin.diagnostics({ bufnr = 0 })
                    end,
                    "Document diagnostics",
                },
                ["D"] = { telescope_builtin.diagnostics, "Workspace diagnostics" },
                ["s"] = { telescope_builtin.lsp_document_symbols, "LSP document symbols" },
                ["S"] = { telescope_builtin.lsp_workspace_symbols, "LSP workspace symbols" },
                ["w"] = {
                    function()
                        telescope_builtin.grep_string({ search = "\\s+$", use_regex = true })
                    end,
                    "Whitespace",
                },
                ["r"] = { telescope_builtin.resume, "Resume" },
            },
        },
    })
end

return M
