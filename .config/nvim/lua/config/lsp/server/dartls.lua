local M = {}

-- https://github.com/akinsho/flutter-tools.nvim
-- slightly modified

local hl_ns = vim.api.nvim_create_namespace("user.config.lsp.server.dartls.hl")

---@param buf integer
local function clear_inlay_hints(buf)
    vim.api.nvim_buf_clear_namespace(buf, hl_ns, 0, -1)
end

local function closing_labels_handler(err, result, ctx)
    if err then
        return
    end

    local buf = vim.uri_to_bufnr(result.uri)
    if not buf then
        return
    end

    clear_inlay_hints(buf)

    local prefix = "// "
    local highlight = "NonText"
    for _, item in ipairs(result.labels) do
        local line = item.range["end"].line
        vim.api.nvim_buf_set_extmark(buf, hl_ns, line, -1, {
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

function M.setup()
    vim.lsp.config("dartls", {
        handlers = {
            ["dart/textDocument/publishClosingLabels"] = closing_labels_handler,
        },
    })
end

return M
