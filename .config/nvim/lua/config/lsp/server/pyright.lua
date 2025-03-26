local M = {}

function M.setup(server, on_init, capabilities)
    server.setup({
        on_init = on_init,
        capabilities = capabilities,
        settings = {},
    })
end

return M
