local M = {}

local lsp_status = require('lsp-status')
local lsp_config = require('lspconfig')
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

function M.show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ 'vim','help' }, filetype) then
        vim.fn.execute('h '..vim.fn.expand('<cword>'))
    elseif vim.tbl_contains({ 'man' }, filetype) then
        vim.fn.execute('Man '..vim.fn.expand('<cword>'))
    elseif vim.fn.expand('%:t') == 'Cargo.toml' then
        require('crates').show_popup()
    else
        vim.lsp.buf.hover()
    end
end

local function on_attach(client)
    lsp_status.on_attach(client)
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

    -- server configurations
    local capabilities = M.get_capabilities()

    lsp_config.rust_analyzer.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importGranularity = "module",
                    importPrefix = "plain",
                },
                cargo = {
                    loadOutDirsFromCheck = true
                },
                procMacro = {
                    enable = true
                },
            },
        },
    }

    lsp_config.ccls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        compilationDatabaseDirectory = "build",
        init_options = {
            cache = {
                directory = ".ccls-cache",
            },
        },
    }

    local sumneko_root_path = vim.fn.expand('~/Projects/lua-language-server')
    local sumneko_binary = sumneko_root_path.."/bin/Linux/lua-language-server"
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    lsp_config.sumneko_lua.setup {
        cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    path = runtime_path,
                },
                diagnostics = {
                    globals = { 'vim', 'P' },
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    }


    -- Diagnostics
    vim.fn.sign_define("LspDiagnosticsSignError",       { text="", texthl="LspDiagnosticsSignError",       linehl="", numhl="" })
    vim.fn.sign_define("LspDiagnosticsSignWarning",     { text="", texthl="LspDiagnosticsSignWarning",     linehl="", numhl="" })
    vim.fn.sign_define("LspDiagnosticsSignHint",        { text="", texthl="LspDiagnosticsSignHint",        linehl="", numhl="" })
    vim.fn.sign_define("LspDiagnosticsSignInformation", { text="", texthl="LspDiagnosticsSignInformation", linehl="", numhl="" })


    --Show inlay hints
    vim.cmd("augroup LspInlayHints")
    vim.cmd("autocmd!")
    vim.cmd("autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * "
            .."lua require('lsp_extensions').inlay_hints { "
            .."prefix = '', highlight = 'NonText', "
            .."enabled = { 'TypeHint', 'ChainingHint' } }")
    vim.cmd("augroup END")

    -- Highlight occurences
    vim.cmd([[
        augroup LspOccurences
        autocmd!
        autocmd CursorHold  * silent lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved * silent lua vim.lsp.buf.clear_references()
        augroup END
    ]])


    -- Show documentation
    maps.nnoremap("K", M.show_documentation)

    -- Signature help
    maps.nnoremap("<c-k>", vim.lsp.buf.signature_help)

    -- Code actions
    maps.nnoremap("<leader>a", vim.lsp.buf.code_action)
    maps.nnoremap("<leader>r", vim.lsp.buf.rename)

    -- Goto actions
    maps.nnoremap("gd", vim.lsp.buf.definition)
    maps.nnoremap("gD", vim.lsp.buf.declaration)
    maps.nnoremap("gw", vim.lsp.buf.document_symbol)
    maps.nnoremap("gW", vim.lsp.buf.workspace_symbol)
    maps.nnoremap("g[", vim.lsp.diagnostic.goto_prev)
    maps.nnoremap("g]", vim.lsp.diagnostic.goto_next)
end

return M
