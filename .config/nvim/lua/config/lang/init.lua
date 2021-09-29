local M = {}

function M.setup()
    require('config.lang.markdown').setup()
    require('config.lang.rust').setup()
end

return M
