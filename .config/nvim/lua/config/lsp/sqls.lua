local M = {}

function M.setup(lsp_config, on_attach, capabilities)
    lsp_config.sqls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

return M
