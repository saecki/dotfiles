local M = {}

local lsp_status = require('lsp-status')
local lsp_config = require('lspconfig')

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
    local filetype = vim.opt.filetype._value
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
end

return M
