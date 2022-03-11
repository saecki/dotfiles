local M = {}

local lsp_installer = require("nvim-lsp-installer")
local wk = require("which-key")
local maps = require("util.maps")

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
    if client.resolved_capabilities.document_highlight then
        vim.cmd([[
            augroup ConfigLspOccurences
            autocmd! * <buffer>
            autocmd CursorHold  <buffer> silent lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> silent lua vim.lsp.buf.clear_references()
            augroup END
        ]])
    end

    wk.register({
        ["<C-LeftMouse>"] = { "<LeftMouse>"..maps.rhs(vim.lsp.buf.definition), "LSP definition" },

        ["<c-a-l>"] = { vim.lsp.buf.formatting, "Formating" },
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

    -- Installer and server config
    lsp_installer.on_server_ready(function(server)
        local success, server_config = pcall(require, "config.lsp.server." .. server.name)
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

    -- Diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = {
            spacing = 2,
            severity_limit = "Warning",
        },
    })

    -- Show documentation
    wk.register({
        ["K"] = { M.show_documentation, "Show documentation" },
    })
end

return M
