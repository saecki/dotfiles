local M = {}

local namespace = vim.api.nvim_create_namespace("config.lsp.server.rust_analyzer")

local function inlay_hints_handler(err, result, ctx)
    if err then
        return
    end

    vim.api.nvim_buf_clear_namespace(ctx.bufnr, namespace, 0, -1)

    local prefix = " "
    local highlight = "NonText"
    local enabled = { "TypeHint", "ChainingHint" }
    local hints = {}
    for _, item in ipairs(result) do
        if vim.tbl_contains(enabled, item.kind) then
            local line = tonumber(item.range["end"].line)
            hints[line] = hints[line] or {}
            table.insert(hints[line], prefix .. item.label)
        end
    end

    for l, t in pairs(hints) do
        local text = table.concat(t, " ")
        vim.api.nvim_buf_set_extmark(ctx.bufnr, namespace, l, -1, {
            virt_text = { { text, highlight } },
            virt_text_pos = "eol",
            hl_mode = "combine",
        })
    end
end

function M.inlay_hints()
    local params = { textDocument = vim.lsp.util.make_text_document_params() }
    vim.lsp.buf_request(0, "rust-analyzer/inlayHints", params, inlay_hints_handler)
end

function M.setup(server, on_init, on_attach, capabilities)
    local function m_on_attach(client, buf)
        on_attach(client, buf)

        local old_progress_handler = vim.lsp.handlers['$/progress']
        vim.lsp.handlers['$/progress'] = function(err, result, ctx, config)
            if old_progress_handler then
                old_progress_handler(err, result, ctx, config)
            end

            if result.value and result.value.kind == "end" then
                M.inlay_hints()
            end
        end

        vim.cmd([[
            augroup LspInlayHints
            autocmd! * <buffer>
            autocmd TextChanged,TextChangedI,TextChangedP,BufEnter,BufWinEnter,TabEnter,BufWritePost <buffer>
                \ lua require('config.lsp.server.rust_analyzer').inlay_hints()
            augroup END
        ]])
    end

    server:setup({
        on_init = on_init,
        on_attach = m_on_attach,
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importGranularity = "module",
                    importPrefix = "plain",
                },
                inlayHints = {
                    maxLength = 40,
                }
            },
        },
        handlers = {
            ["textDocument/publishClosingLabels"] = function() M.inlay_hints() end,
        },
    })
end

return M
