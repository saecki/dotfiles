local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local wk = require("which-key.config")

local M = {}

local function find_files(opts)
    return function()
        local fd_cmd = { "fd", "--type", "f", "--exclude", ".git", "--hidden" }
        telescope_builtin.find_files({
            find_command = fd_cmd,
            no_ignore = opts.no_ignore,
        })
    end
end

local function buf_diagnostics()
    telescope_builtin.diagnostics({ bufnr = 0 })
end

local function trailing_whitespace()
    telescope_builtin.grep_string({ search = "\\s+$", use_regex = true })
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

    wk.add({
        { "<leader>f",  group = "Find" },
        { "<leader>fp", find_files({ no_ignore = false }),       desc = "Files" },
        { "<leader>fP", find_files({ no_ignore = true }),        desc = "Ignored Files" },
        { "<leader>ff", telescope_builtin.live_grep,             desc = "Live grep" },
        { "<leader>fb", telescope_builtin.buffers,               desc = "Buffers" },
        { "<leader>fh", telescope_builtin.help_tags,             desc = "Help" },
        { "<leader>fc", telescope_builtin.commands,              desc = "Commands" },
        { "<leader>fm", telescope_builtin.keymaps,               desc = "Key mappings" },
        { "<leader>fi", telescope_builtin.highlights,            desc = "Highlight groups" },
        { "<leader>fg", telescope_builtin.git_status,            desc = "Git status" },
        { "<leader>fd", buf_diagnostics,                         desc = "Document diagnostics" },
        { "<leader>fD", telescope_builtin.diagnostics,           desc = "Workspace diagnostics" },
        { "<leader>fs", telescope_builtin.lsp_document_symbols,  desc = "LSP document symbols" },
        { "<leader>fS", telescope_builtin.lsp_workspace_symbols, desc = "LSP workspace symbols" },
        { "<leader>fw", trailing_whitespace,                     desc = "Whitespace", },
        { "<leader>fr", telescope_builtin.resume,                desc = "Resume" },
    })
end

return M
