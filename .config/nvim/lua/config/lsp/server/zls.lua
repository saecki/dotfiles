local M = {}

local wk = require("which-key")

function M.setup(server, on_init, on_attach, capabilities)
    server.setup({
        on_init = on_init,
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {},
    })
end

return M
