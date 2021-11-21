local M = {}

local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')
local maps = require('util.maps')

function M.setup()
    telescope.setup {
        defaults = {
            layout_config = {
                horizontal = {
                    width = 0.9,
                    height = 0.9,
                    preview_cutoff = 120,
                },
            },
        },
    }


    local fd_cmd = { "fd", "--type", "f", "--exclude", ".git", "--hidden" }
    maps.nnoremap("<a-p>",      function() telescope_builtin.find_files { find_command = fd_cmd, no_ignore = true } end)
    maps.nnoremap("<c-p>",      function() telescope_builtin.find_files { find_command = fd_cmd } end)
    maps.nnoremap("<leader>s",  telescope_builtin.live_grep)
    maps.nnoremap("<leader>;",  telescope_builtin.buffers)
    maps.nnoremap("<leader>fh", telescope_builtin.help_tags)
    maps.nnoremap("<leader>fc", telescope_builtin.commands)
    maps.nnoremap("<leader>fm", telescope_builtin.keymaps)
    maps.nnoremap("<leader>fi", telescope_builtin.highlights)
    maps.nnoremap("<leader>fr", telescope_builtin.resume)
end

return M
