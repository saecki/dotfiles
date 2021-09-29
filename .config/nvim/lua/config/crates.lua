local M = {}

local crates = require('crates')
local maps = require('util.maps')

function M.setup()
    crates.setup {
        popup = {
            version_date = true,
        }
    }

    maps.nnoremap("<leader>vt", crates.toggle)
    maps.nnoremap("<leader>vr", crates.reload)
    maps.nnoremap("<leader>vu", crates.update_crate)
    maps.vnoremap("<leader>vu", crates.update_crates)
    maps.nnoremap("<leader>va", crates.update_all_crates)
    maps.nnoremap("<leader>vU", crates.upgrade_crate)
    maps.vnoremap("<leader>vU", crates.upgrade_crates)
    maps.nnoremap("<leader>vA", crates.upgrade_all_crates)
end

return M
