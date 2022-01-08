local M = {}

-- https://github.com/akinsho/flutter-tools.nvim
-- slightly modified
local namespace = vim.api.nvim_create_namespace("config.lsp.server.dartls")

local function closing_labels_handler(err, result, ctx)
    if err then
        return
    end

    vim.api.nvim_buf_clear_namespace(ctx.bufnr, namespace, 0, -1)

    local prefix = "// "
    local highlight = "NonText"
    for _, item in ipairs(result.labels) do
        local line = item.range["end"].line
        vim.api.nvim_buf_set_extmark(ctx.bufnr, namespace, tonumber(line), -1, {
            virt_text = { {
                prefix .. item.label,
                highlight,
            } },
            virt_text_pos = "eol",
            hl_mode = "combine",
        })
    end
end

function M.setup(server, on_init, on_attach, capabilities)
    server:setup({
        on_init = on_init,
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = {
            ["dart/textDocument/publishClosingLabels"] = closing_labels_handler,
        },
    })
end

return M
