local M = {}

function M.setup(lsp_config, on_attach, capabilities)
    lsp_config.rust_analyzer.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importGranularity = "module",
                    importPrefix = "plain",
                },
            },
        },
    }
end

return M
