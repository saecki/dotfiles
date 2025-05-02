local M = {}

function M.setup()
    vim.lsp.config("tinymist", {
        settings = {
            formatterMode = "typstyle",
        },
    })
end

return M
