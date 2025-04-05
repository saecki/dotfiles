local M = {}

-- https://github.com/akinsho/flutter-tools.nvim
-- slightly modified
local namespace = vim.api.nvim_create_namespace("user.config.lsp.server.dartls")

local function closing_labels_handler(err, result, ctx)
    if err then
        return
    end

    local bufnr = vim.uri_to_bufnr(result.uri)
    if not bufnr then
        return
    end

    M.clear_inlay_hints(bufnr)

    local prefix = "// "
    local highlight = "NonText"
    for _, item in ipairs(result.labels) do
        local line = tonumber(item.range["end"].line)
        vim.api.nvim_buf_set_extmark(bufnr, namespace, line, -1, {
            virt_text = {
                {
                    prefix .. item.label,
                    highlight,
                },
            },
            virt_text_pos = "eol",
            hl_mode = "combine",
        })
    end
end

function M.clear_inlay_hints(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr or 0, namespace, 0, -1)
end

function M.setup(server)
    server.setup({
        handlers = {
            ["dart/textDocument/publishClosingLabels"] = closing_labels_handler,
        },
    })
end

return M
