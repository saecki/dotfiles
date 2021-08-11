local lsp_status = require('lsp-status')
lsp_status.register_progress()
lsp_status.config {
    status_symbol = "LSP",
    current_function = false,
    diagnostics = false,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}
capabilities.window = capabilities.window or {
    workDoneProgress = true
}

local lsp_config = require('lspconfig')
lsp_config.rust_analyzer.setup {
    on_attach = lsp_status.on_attach,
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

