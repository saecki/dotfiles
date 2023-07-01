local M = {}

local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_ui = require("mason.ui")
local wk = require("which-key")
local shared = require("shared")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local DOCUMENT_HIGHLIGHT_HANDLER = vim.lsp.handlers["textDocument/documentHighlight"]
local document_highlight = true

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
                if document_highlight then
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
            ["d"] = { vim.lsp.buf.definition, "LSP definition" },
            ["D"] = { vim.lsp.buf.declaration, "LSP declaration" },
        },
        ["<leader>"] = {
            ["a"] = { vim.lsp.buf.code_action, "Code action" },
            ["eh"] = {
                function()
                    document_highlight = not document_highlight
                    if not document_highlight then
                        vim.lsp.buf.clear_references()
                    else
                        vim.lsp.buf.document_highlight()
                    end
                end,
                "Document highlight",
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
            ["a"] = { ":lua vim.lsp.buf.range_code_action()<cr>", "Range code action" },
        },
    }, {
        mode = "x",
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

    local servers = {
        "arduino_language_server",
        "clangd",
        "dartls",
        "rust_analyzer",
        "lua_ls",
        "texlab",
    }
    for _, s in ipairs(servers) do
        local server = require("config.lsp.server." .. s)
        server.setup(lspconfig[s], M.on_init, M.on_attach, capabilities)
    end

    -- Setup lsp installer
    mason.setup({
        ui = {
            border = shared.border,
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
