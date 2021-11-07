local M = {}

local util = require('util')

function M.setup(server, on_attach, capabilities)
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, util.join_paths("lua", "?.lua"))
    table.insert(runtime_path, util.join_paths("lua", "?", "init.lua"))

    server:setup {
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
end

return M
