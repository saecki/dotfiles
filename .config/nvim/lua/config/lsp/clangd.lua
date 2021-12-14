local M = {}

local lsp_status = require("lsp-status")

function M.setup(server, on_init, on_attach, capabilities)
    server:setup({
        handlers = lsp_status.extensions.clangd.setup(),
        on_init = on_init,
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

return M
