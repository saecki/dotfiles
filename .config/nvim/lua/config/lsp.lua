local function get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.preselectSupport = true
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
    capabilities.textDocument.completion.completionItem.deprecatedSupport = true
    capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
    capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    }
    capabilities.window = {
        workDoneProgress = true
    }
    return capabilities
end

local function setup_lsp_status()
    local lsp_status = require('lsp-status')
    lsp_status.register_progress()
    lsp_status.config {
        status_symbol = "LSP",
        current_function = false,
        diagnostics = false,
    }
    return lsp_status
end

local function on_attach(client)
    require('lsp-status').on_attach(client)
end

local function setup()
    local capabilities = get_capabilities()
    local lsp_status = setup_lsp_status()

    local lsp_config = require('lspconfig')
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

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            signs = true,
            update_in_insert = true,
            severity_sort = true,
        }
    )
end

return { 
    setup = setup
}
