local M = {}

function M.setup(server, on_attach, capabilities)
    local function m_on_attach(client, bufnr)
        on_attach(client, bufnr)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>fw", ":TexlabForward<cr>", { silent = true })
    end
    server:setup {
        on_attach = m_on_attach,
        capabilities = capabilities,
        settings = {
            texlab = {
                build = {
                    executable = "latexmk",
                    args = { "-xelatex", "-verbose", "-file-line-error", "-interaction=nonstopmode", "-synctex=1", "%f"},
                    forwardSearchAfter = true,
                    onSave = true,
                },
                chktex = {
                    onOpenAndSave = true,
                    onEdit = true,
                },
                forwardSearch = {
                    executable = "zathura",
                    args = { "--synctex-forward", "%l:1:%f", "%p" },
                },
            },
        },
    }
end

return M