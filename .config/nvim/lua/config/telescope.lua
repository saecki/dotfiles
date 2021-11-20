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

    maps.nmap("<leader>s",  telescope_builtin.live_grep)
    maps.nmap("<a-p>",      function() telescope_builtin.find_files { hidden = true, no_ignore = true } end)
    maps.nmap("<c-p>",      function() telescope_builtin.find_files { hidden = true } end)
    maps.nmap("<leader>;",  telescope_builtin.buffers)
    maps.nmap("<leader>fh", telescope_builtin.help_tags)
    maps.nmap("<leader>fc", telescope_builtin.commands)
    maps.nmap("<leader>fm", telescope_builtin.keymaps)
    maps.nmap("<leader>fi", telescope_builtin.highlights)
end

return M
