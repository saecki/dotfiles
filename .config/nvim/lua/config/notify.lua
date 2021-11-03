local M = {}

local notify = require('notify')
local maps = require('util.maps')

function M.setup()
    vim.notify = notify

    maps.nnoremap("<leader>nd", notify.dismiss)
end

return M
