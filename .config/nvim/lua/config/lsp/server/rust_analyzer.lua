local M = {}

local shared = require("shared")

local KIND = {
    OTHER = 1,
    PARAM_HINTS = 2,
}

local namespace = vim.api.nvim_create_namespace("config.lsp.server.rust_analyzer")
local enable_inlay_hints = true

local function inlay_hints_handler(err, result, ctx)
    if err then
        return
    end
    if not shared.lsp.enable_inlay_hints then
        return
    end

    M.clear_inlay_hints(ctx.bufnr)

    local prefix = " "
    local highlight = "NonText"
    local hints = {}
    for _, item in ipairs(result) do
        if item.kind == KIND.OTHER then
            local line = tonumber(item.position.line)
            hints[line] = hints[line] or {}

            local text = ""
            if type(item.label) == "table" then
                local labels = vim.tbl_map(function(i) return i.value end, item.label)
                text = table.concat(labels)
            else -- string
                text = item.label
            end
            local text = text:gsub(": ", "")
            table.insert(hints[line], prefix .. text)
        end
    end

    for l, t in pairs(hints) do
        local text = table.concat(t, " ")
        vim.api.nvim_buf_set_extmark(ctx.bufnr, namespace, l, 0, {
            virt_text = { { text, highlight } },
            virt_text_pos = "eol",
            hl_mode = "combine",
        })
    end
end

function M.inlay_hints()
    if not shared.lsp.enable_inlay_hints then
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local line_count = vim.api.nvim_buf_line_count(bufnr) - 1
    local last_line = vim.api.nvim_buf_get_lines(bufnr, line_count, line_count + 1, true)

    local params = {
        textDocument = vim.lsp.util.make_text_document_params(bufnr),
        range = {
            start = {
                line = 0,
                character = 0,
            },
            ["end"] = {
                line = line_count,
                character = #last_line[1],
            },
        },
    }

    vim.lsp.buf_request(0, "textDocument/inlayHint", params, inlay_hints_handler)
end

function M.clear_inlay_hints(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr or 0, namespace, 0, -1)
end

function M.setup(server, on_init, on_attach, capabilities)
    local function m_on_attach(client, buf)
        on_attach(client, buf)

        -- hook into the progress handler so we can show inlay hints
        -- when the language server has started up.
        local old_progress_handler = vim.lsp.handlers["$/progress"]
        vim.lsp.handlers["$/progress"] = function(err, result, ctx, config)
            if old_progress_handler then
                old_progress_handler(err, result, ctx, config)
            end

            if result.value and result.value.kind == "end" then
                M.inlay_hints()
            end
        end

        local group = vim.api.nvim_create_augroup("LspInlayHints", {})
        vim.api.nvim_create_autocmd(
            { "TextChanged", "TextChangedI", "TextChangedP", "BufEnter", "BufWinEnter", "TabEnter", "BufWritePost" },
            {
                group = group,
                buffer = buf,
                callback = M.inlay_hints,
            }
        )

        M.inlay_hints()
    end

    server.setup({
        on_init = on_init,
        on_attach = m_on_attach,
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importEnforceGranularity = true,
                    importGranularity = "module",
                    importPrefix = "plain",
                },
                inlayHints = {
                    maxLength = 40,
                },
            },
        },
    })
end

return M
