local M = {}

function M.setup(server, on_attach, capabilities)
    server:setup({
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

return M
