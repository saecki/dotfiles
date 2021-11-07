local M = {}

function M.setup(server, on_attach, capabilities)
    server:setup {
        on_attach = on_attach,
        capabilities = capabilities,
        compilationDatabaseDirectory = "build",
        init_options = {
            cache = {
                directory = ".ccls-cache",
            },
        },
    }
end

return M
