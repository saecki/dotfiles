local M = {}

local lsp_status = require('lsp-status')
local lsp_installer = require('nvim-lsp-installer')
local maps = require('util.maps')

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
            valueSet = { 1 }
        },
        resolveSupport = {
            properties = {
                'documentation',
                'detail',
                'additionalTextEdits',
            }
        }
    }
    capabilities.window = {
        workDoneProgress = true
    }
    return capabilities
end

function M.on_attach(client)
    lsp_status.on_attach(client)
end

function M.show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ 'vim','help' }, filetype) then
        vim.cmd('h '..vim.fn.expand('<cword>'))
    elseif vim.tbl_contains({ 'man' }, filetype) then
        vim.cmd('Man '..vim.fn.expand('<cword>'))
    elseif vim.fn.expand('%:t') == 'Cargo.toml' then
        require('crates').show_popup()
    else
        vim.lsp.buf.hover()
    end
end

function M.setup()
    -- status
    lsp_status.register_progress()
    lsp_status.config {
        status_symbol = "LSP",
        current_function = false,
        diagnostics = false,
    }

    -- diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            signs = true,
            update_in_insert = true,
            severity_sort = true,
        }
    )

    -- client capabilities
    local capabilities = M.get_capabilities()

    -- installer and server config
    local server_configs = {
        "rust_analyzer",
        "clangd",
        "sumneko_lua",
        "sqls",
        "texlab",
    }

    lsp_installer.on_server_ready(function(server)
        if vim.tbl_contains(server_configs, server.name) then
            require("config.lsp."..server.name).setup(server, M.on_attach, capabilities)
        else
            server:setup {
                on_attach = M.on_attach,
                capabilities = M.capabilities,
            }
        end
    end)

    -- Diagnostics
    vim.fn.sign_define("LspDiagnosticsSignError",       { text="", texthl="LspDiagnosticsSignError",       linehl="", numhl="" })
    vim.fn.sign_define("LspDiagnosticsSignWarning",     { text="", texthl="LspDiagnosticsSignWarning",     linehl="", numhl="" })
    vim.fn.sign_define("LspDiagnosticsSignHint",        { text="", texthl="LspDiagnosticsSignHint",        linehl="", numhl="" })
    vim.fn.sign_define("LspDiagnosticsSignInformation", { text="", texthl="LspDiagnosticsSignInformation", linehl="", numhl="" })

    -- Inlay hints
    vim.cmd("augroup LspInlayHints")
    vim.cmd("autocmd!")
    vim.cmd("autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * "
            .."lua require('lsp_extensions').inlay_hints { "
            .."prefix = '', highlight = 'NonText', "
            .."enabled = { 'TypeHint', 'ChainingHint' } }")
    vim.cmd("augroup END")

    -- Occurences
    vim.cmd([[
        augroup LspOccurences
        autocmd!
        autocmd CursorHold  * silent lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved * silent lua vim.lsp.buf.clear_references()
        augroup END
    ]])

    -- Show documentation
    maps.nnoremap("K", M.show_documentation)
    -- Show Signature
    maps.nnoremap("S", vim.lsp.buf.signature_help)

    -- Code actions
    maps.nnoremap("<leader>a", vim.lsp.buf.code_action)
    maps.nnoremap("<leader>r", function()
        require('util.float').input(nil, false, function(new_name)
            vim.lsp.buf.rename(new_name)
        end)
    end)
    maps.nnoremap("<leader>R", function()
        require('util.float').input("", true, function(new_name)
            vim.lsp.buf.rename(new_name)
        end)
    end)

    -- Goto actions
    maps.nnoremap("gd", vim.lsp.buf.definition)
    maps.nnoremap("gD", vim.lsp.buf.declaration)
    maps.nnoremap("gw", vim.lsp.buf.document_symbol)
    maps.nnoremap("gW", vim.lsp.buf.workspace_symbol)
    maps.nnoremap("g[", vim.lsp.diagnostic.goto_prev)
    maps.nnoremap("g]", vim.lsp.diagnostic.goto_next)
end

return M
