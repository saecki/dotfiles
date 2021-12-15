local M = {}

local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
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

    maps.nnoremap("<a-p>", function()
        find_files(true)
    end)
    maps.nnoremap("<c-p>", function()
        find_files(false)
    end)
    maps.nnoremap("<leader>s", telescope_builtin.live_grep)
    maps.nnoremap("<leader>;", telescope_builtin.buffers)
    maps.nnoremap("<leader>fh", telescope_builtin.help_tags)
    maps.nnoremap("<leader>fc", telescope_builtin.commands)
    maps.nnoremap("<leader>fm", telescope_builtin.keymaps)
    maps.nnoremap("<leader>fi", telescope_builtin.highlights)
    maps.nnoremap("<leader>fg", telescope_builtin.git_status)
    maps.nnoremap("<leader>fd", telescope_builtin.lsp_document_symbols)
    maps.nnoremap("<leader>fw", telescope_builtin.lsp_workspace_symbols)
    maps.nnoremap("<leader>fr", telescope_builtin.resume)
end

return M
