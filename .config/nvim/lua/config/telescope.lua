local M = {}

local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local wk = require("which-key")
local maps = require("util.maps")

local function find_files(no_ignore)
    local fd_cmd = { "fd", "--type", "f", "--exclude", ".git", "--hidden" }
    telescope_builtin.find_files({
        find_command = fd_cmd,
        no_ignore = no_ignore,
    })
end

function M.setup()
    telescope.setup({
        defaults = {
            layout_config = {
                horizontal = {
                    width = 0.9,
                    height = 0.9,
                    preview_cutoff = 120,
                },
            },
        },
    })

    wk.register({
        ["<a-p>"] = { maps.rhs(find_files, true), "Find ignored files" },
        ["<c-p>"] = { maps.rhs(find_files, false), "Find files" },
        ["<leader>"] = {
            ["s"] = { telescope_builtin.live_grep, "Search text" },
            [";"] = { telescope_builtin.buffers, "Search buffers" },
            ["f"] = {
                name = "Find",
                ["h"] = { telescope_builtin.help_tags, "Help" },
                ["c"] = { telescope_builtin.commands, "Commands" },
                ["m"] = { telescope_builtin.keymaps, "Key mappings" },
                ["i"] = { telescope_builtin.highlights, "Highlight groups" },
                ["g"] = { telescope_builtin.git_status, "Git status" },
                ["d"] = { maps.rhs(telescope_builtin.diagnostics, { bufnr = 0 }), "Document diagnostics" },
                ["D"] = { telescope_builtin.diagnostics, "Workspace diagnostics" },
                ["s"] = { telescope_builtin.lsp_document_symbols, "Lsp document symbols" },
                ["S"] = { telescope_builtin.lsp_workspace_symbols, "Lsp workspace symbols" },
                ["r"] = { telescope_builtin.resume, "Resume" },
                ["w"] = { maps.rhs(telescope_builtin.grep_string, { search = "\\s+$", use_regex = true }), "Whitespace" },
            },
        },
    })
end

return M
