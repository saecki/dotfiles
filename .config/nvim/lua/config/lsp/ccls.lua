local M = {}

function M.setup(lsp_config, on_attach, capabilities)
    lsp_config.ccls.setup {
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
