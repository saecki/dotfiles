local M = {}

local lsp_config = require("lspconfig")
local mason = require("mason")
local mason_ui = require("mason.ui")
local wk = require("which-key")
local shared = require("shared")

local DOCUMENT_HIGHLIGHT_HANDLER = vim.lsp.handlers["textDocument/documentHighlight"]

function M.get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem = {
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = {
            valueSet = { 1 },
        },
        resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        },
    }
    capabilities.window = {
        workDoneProgress = true,
    }
    return capabilities
end

function M.on_init(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
end

function M.on_attach(client, buf)
    -- Occurences
    if client.server_capabilities.document_highlight then
        local group = vim.api.nvim_create_augroup("ConfigLspOccurences", {})
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = group,
            buffer = buf,
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
        })
    end

    wk.register({
        ["<C-LeftMouse>"] = { "<LeftMouse><cmd>lua vim.lsp.buf.definition()<cr>", "LSP definition" },

        ["<c-a-l>"] = { vim.lsp.buf.format, "Formating" },
        ["<a-k>"] = { vim.lsp.buf.signature_help, "Signature help" },
        ["g"] = {
            name = "Go",
            ["d"] = { vim.lsp.buf.definition, "LSP definition" },
            ["D"] = { vim.lsp.buf.declaration, "LSP declaration" },
        },
        ["<leader>"] = {
            ["a"] = { vim.lsp.buf.code_action, "Code action" },
            ["r"] = {
                function()
                    require("util.input").input(nil, false, function(new_name)
                        vim.lsp.buf.rename(new_name)
                    end)
                end,
                "Refactor keep name",
            },
            ["R"] = {
                function()
                    require("util.input").input("", true, function(new_name)
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
    local servers = {
        "arduino_language_server",
        "clangd",
        "dartls",
        "rust_analyzer",
        "sqls",
        "sumneko_lua",
        "texlab",
    }
    for _,s in ipairs(servers) do
        local server = require("config.lsp.server." .. s)
        server.setup(lsp_config[s], M.on_init, M.on_attach, capabilities)
    end

    -- Setup servers
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

    -- Show documentation
    wk.register({
        ["K"] = { M.show_documentation, "Show documentation" },
        ["<leader>i"] = {
            name = "Lsp",
            ["s"] = { ":LspStart<cr>", "Start" },
            ["r"] = { ":LspRestart<cr>", "Restart" },
            ["t"] = { ":LspStop<cr>", "Stop" },
            ["i"] = { ":LspInfo<cr>", "Info" },
            ["I"] = { mason_ui.open, "Install Info" },
            ["l"] = { ":LspInstallLog<cr>", "Install Log" },
        },
    })
end

return M
