local M = {}

function M.setup(server, on_attach, capabilities)
    local function m_on_attach(client, buf)
        on_attach(client, buf)
        vim.cmd([[
            augroup LspInlayHints
            autocmd! *
            autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs lua require('lsp_extensions').inlay_hints { prefix = '  ', highlight = 'NonText', enabled = { 'TypeHint', 'ChainingHint' } }
            augroup END
        ]])
    end

    server:setup({
        on_attach = m_on_attach,
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importGranularity = "module",
                    importPrefix = "plain",
                },
            },
        },
    })
end

return M
