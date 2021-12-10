local M = {}

function M.setup(server, on_attach, capabilities)
    local function m_on_attach(client, bufnr)
        on_attach(client, bufnr)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<c-a>l", ":RustFmt<cr>", { silent = true })
    end
    server:setup {
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
    }
end

return M
