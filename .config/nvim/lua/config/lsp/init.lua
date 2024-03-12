local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local mason = require("mason")
local mason_ui = require("mason.ui")
local wk = require("which-key")
local shared = require("shared")
-- servers
local arduino_language_server = require("config.lsp.server.arduino_language_server")
local dartls = require("config.lsp.server.dartls")
local lua_ls = require("config.lsp.server.lua_ls")
local rust_analyzer = require("config.lsp.server.rust_analyzer")
local texlab = require("config.lsp.server.texlab")

local M = {}

local group

local function default_server_setup(server, on_attach, capabilities)
    server.setup ({
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

function M.get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = cmp_nvim_lsp.default_capabilities()
    local fidget_capabilities = { capabilities = { window = { workDoneProgress = true } } }
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities, fidget_capabilities)
    return capabilities
end

function M.on_attach(client, buf)
    -- Occurences
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = group,
            buffer = buf,
            callback = function()
                if shared.lsp.enable_document_highlight then
                    vim.lsp.buf.document_highlight()
                end
            end,
        })
    end

    -- Inlay hints
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(buf, shared.lsp.enable_inlay_hints)
    end

    wk.register({
        ["<c-LeftMouse>"] = { "<LeftMouse><cmd>lua vim.lsp.buf.definition()<cr>", "LSP definition" },

        ["<c-a-l>"] = { vim.lsp.buf.format, "Formating" },
        ["K"] = { vim.lsp.buf.hover, "Show documentation" },
        ["<a-k>"] = { vim.lsp.buf.signature_help, "Signature help" },
        ["g"] = {
            name = "Go",
            ["D"] = { vim.lsp.buf.declaration, "LSP declaration" },
        },
        ["<leader>"] = {
            ["a"] = { vim.lsp.buf.code_action, "Code action" },
            ["eh"] = {
                function()
                    shared.lsp.enable_document_highlight = not shared.lsp.enable_document_highlight
                    if not shared.lsp.enable_document_highlight then
                        vim.lsp.buf.clear_references()
                    else
                        vim.lsp.buf.document_highlight()
                    end
                end,
                "Document highlight",
            },
            ["ei"] = {
                function()
                    -- TODO: this will only update the current buffer
                    shared.lsp.enable_inlay_hints = not shared.lsp.enable_inlay_hints
                    vim.lsp.inlay_hint.enable(buf, shared.lsp.enable_inlay_hints)
                end,
                "Inlay hints",
            },
            ["r"] = {
                function()
                    require("util.input").input({}, function(new_name)
                        vim.lsp.buf.rename(new_name)
                    end)
                end,
                "Refactor keep name",
            },
            ["R"] = {
                function()
                    require("util.input").input({ text = "", insert = true }, function(new_name)
                        vim.lsp.buf.rename(new_name)
                    end)
                end,
                "Refactor clear name",
            },
        },
    }, {
        buffer = buf,
    })

    wk.register({
        ["<leader>"] = {
            ["a"] = {
                function()
                    vim.lsp.buf.code_action()
                    vim.api.nvim_input("<ESC>")
                end,
                "Range code action",
            },
        },
    }, {
        mode = "v",
        buffer = buf,
    })
end

function M.setup()
    group = vim.api.nvim_create_augroup("user.config.lsp", {})

    -- Client capabilities
    local capabilities = M.get_capabilities()

    -- Setup servers
    lspconfig.util.default_config.autostart = false

    default_server_setup(lspconfig["clangd"], M.on_attach, capabilities)
    default_server_setup(lspconfig["zls"], M.on_attach, capabilities)
    default_server_setup(lspconfig["wgsl_analyzer"], M.on_attach, capabilities)
    default_server_setup(lspconfig["pyright"], M.on_attach, capabilities)

    arduino_language_server.setup(lspconfig["arduino_language_server"], M.on_attach, capabilities)
    dartls.setup(lspconfig["dartls"], M.on_attach, capabilities)
    lua_ls.setup(lspconfig["lua_ls"], M.on_attach, capabilities)
    rust_analyzer.setup(lspconfig["rust_analyzer"], M.on_attach, capabilities)
    texlab.setup(lspconfig["texlab"], M.on_attach, capabilities)

    -- window border
    require("lspconfig.ui.windows").default_options.border = shared.window.border

    -- Setup lsp installer
    mason.setup({
        ui = {
            border = shared.window.border,
        },
    })

    -- Diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = {
            spacing = 2,
            severity = { min = "Warn" },
        },
    })

    -- Occurences
    vim.lsp.handlers["textDocument/documentHighlight"] = function(err, result, ctx, config)
        -- only clear highlights when the new locations are known to avoid jitter
        vim.lsp.util.buf_clear_references(ctx.bufnr)
        if not result then
            return
        end
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if not client then
            return
        end
        vim.lsp.util.buf_highlight_references(ctx.bufnr, result, client.offset_encoding)
    end

    -- Documentation window border
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = shared.window.border,
    })

    -- Keymappings
    wk.register({
        ["<leader>i"] = {
            name = "Lsp",
            ["s"] = { ":LspStart<cr>", "Start" },
            ["r"] = { ":LspRestart<cr>", "Restart" },
            ["t"] = { ":LspStop<cr>", "Stop (terminate)" },
            ["i"] = { ":LspInfo<cr>", "Info" },
            ["I"] = { mason_ui.open, "Install Info" },
            ["l"] = { ":MasonLog<cr>", "Install Log" },
        },
    })
end

return M
