local M = {}

local lsp_status = require("lsp-status")
local lsp_installer = require("nvim-lsp-installer")
local wk = require("which-key")

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
    -- Status
    lsp_status.on_attach(client)

    -- Occurences
    if client.resolved_capabilities.document_highlight then
        vim.cmd([[
            augroup LspOccurences
            autocmd!
            autocmd CursorHold  * silent lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved * silent lua vim.lsp.buf.clear_references()
            augroup END
        ]])
    end

    wk.register({
        ["<c-a-l>"] = { vim.lsp.buf.formatting_sync, "Formating" },
        ["<a-k>"] = { vim.lsp.buf.signature_help, "Signature help" },
        ["g"] = {
            name = "Go",
            ["d"] = { vim.lsp.buf.definition, "LSP Definition" },
            ["D"] = { vim.lsp.buf.declaration, "LSP Declaration" },
            ["["] = { vim.lsp.diagnostic.goto_prev, "Previous diagnostic" },
            ["]"] = { vim.lsp.diagnostic.goto_next, "Next diagnostic" },
        },
        ["<leader>"] = {
            ["a"] = { vim.lsp.buf.code_action, "Code action" },
            ["r"] = {
                function()
                    require("util.float").input(nil, false, function(new_name)
                        vim.lsp.buf.rename(new_name)
                    end)
                end,
                "Refactor keep name",
            },
            ["R"] = {
                function()
                    require("util.float").input("", true, function(new_name)
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
            ["a"] = { vim.lsp.buf.range_code_action, "Code action" },
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

    -- Installer and server config
    lsp_installer.on_server_ready(function(server)
        local success, server_config = pcall(require, "config.lsp." .. server.name)
        if success then
            server_config.setup(server, M.on_init, M.on_attach, capabilities)
        else
            server:setup({
                on_init = M.on_init,
                on_attach = M.on_attach,
                capabilities = capabilities,
            })
        end
    end)

    -- Status
    lsp_status.register_progress()
    lsp_status.config({
        status_symbol = "LSP",
        current_function = false,
        diagnostics = false,
    })

    -- Diagnostics
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = true,
        severity_sort = true,
    })
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = {
            spacing = 2,
            severity_limit = "Warning",
        },
    })
    local signs = { Error = "", Warn = "", Hint = "", Infor = "" }
    for n, s in pairs(signs) do
        local hl = "DiagnosticSign" .. n
        vim.fn.sign_define(hl, { text = s, texthl = hl, linehl = "", numhl = "" })
    end

    -- Show documentation
    wk.register({
        ["K"] = { M.show_documentation, "Show documentation" },
    })
end

return M
