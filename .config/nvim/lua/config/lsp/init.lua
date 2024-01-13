local M = {}

local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_ui = require("mason.ui")
local wk = require("which-key")
local shared = require("shared")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
-- servers
local arduino_language_server = require("config.lsp.server.arduino_language_server")
local clangd = require("config.lsp.server.clangd")
local dartls = require("config.lsp.server.dartls")
local lua_ls = require("config.lsp.server.lua_ls")
local rust_analyzer = require("config.lsp.server.rust_analyzer")
local texlab = require("config.lsp.server.texlab")
local zls = require("config.lsp.server.zls")

local DOCUMENT_HIGHLIGHT_HANDLER = vim.lsp.handlers["textDocument/documentHighlight"]

function M.inlay_hints()
    local filetype = vim.bo.filetype
    if filetype == "rust" then
        rust_analyzer.inlay_hints()
    end
end

function M.clear_inlay_hints()
    local filetype = vim.bo.filetype
    if filetype == "rust" then
        rust_analyzer.clear_inlay_hints()
    elseif filetype == "dart" then
        dartls.clear_inlay_hints()
    end
end

function M.get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = cmp_nvim_lsp.default_capabilities()
    local fidget_capabilities = { capabilities = { window = { workDoneProgress = true } } }
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities, fidget_capabilities)
    return capabilities
end

function M.on_init(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
end

function M.on_attach(client, buf)
    -- Occurences
    if client.server_capabilities.documentHighlightProvider then
        local group = vim.api.nvim_create_augroup("ConfigLspOccurences", {})
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

    wk.register({
        ["<c-LeftMouse>"] = { "<LeftMouse><cmd>lua vim.lsp.buf.definition()<cr>", "LSP definition" },

        ["<c-a-l>"] = { vim.lsp.buf.format, "Formating" },
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
                    shared.lsp.enable_inlay_hints = not shared.lsp.enable_inlay_hints
                    if not shared.lsp.enable_inlay_hints then
                        M.clear_inlay_hints()
                    else
                        M.inlay_hints()
                    end
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

function M.show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ "vim", "help" }, filetype) then
        vim.cmd("h " .. vim.fn.expand("<cword>"))
    elseif vim.tbl_contains({ "man" }, filetype) then
        vim.cmd("Man " .. vim.fn.expand("<cword>"))
    elseif vim.fn.expand("%:t") == "Cargo.toml" then
        require("crates").show_popup()
    else
        vim.lsp.buf.hover()
    end
end

function M.setup()
    -- Client capabilities
    local capabilities = M.get_capabilities()

    -- Setup servers
    lspconfig.util.default_config.autostart = false

    arduino_language_server.setup(lspconfig["arduino_language_server"], M.on_init, M.on_attach, capabilities)
    clangd.setup(lspconfig["clangd"], M.on_init, M.on_attach, capabilities)
    dartls.setup(lspconfig["dartls"], M.on_init, M.on_attach, capabilities)
    lua_ls.setup(lspconfig["lua_ls"], M.on_init, M.on_attach, capabilities)
    rust_analyzer.setup(lspconfig["rust_analyzer"], M.on_init, M.on_attach, capabilities)
    texlab.setup(lspconfig["texlab"], M.on_init, M.on_attach, capabilities)
    zls.setup(lspconfig["zls"], M.on_init, M.on_attach, capabilities)

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
            severity_limit = "Warning",
        },
    })

    -- Occurences
    vim.lsp.handlers["textDocument/documentHighlight"] = function(...)
        vim.lsp.buf.clear_references()
        DOCUMENT_HIGHLIGHT_HANDLER(...)
    end

    -- Documentation window border
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = shared.window.border,
    })

    -- Keymappings
    wk.register({
        ["K"] = { M.show_documentation, "Show documentation" },
        ["<leader>i"] = {
            name = "Lsp",
            ["s"] = { ":LspStart<cr>", "Start" },
            ["r"] = { ":LspRestart<cr>", "Restart" },
            ["t"] = { ":LspStop<cr>", "Stop (terminate)" },
            ["i"] = { ":LspInfo<cr>", "Info" },
            ["I"] = { mason_ui.open, "Install Info" },
            ["l"] = { ":LspInstallLog<cr>", "Install Log" },
        },
    })
end

return M
