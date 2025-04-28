local M = {}

function M.setup()
    vim.lsp.config("lua_ls", {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                workspace = {
                    checkThirdParty = true,
                    library = {
                        vim.env.VIMRUNTIME,
                        '${3rd}/busted/library',
                        '${3rd}/luv/library',
                        '${3rd}/luassert/library',
                    },
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })
end

return M
