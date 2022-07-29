local M = {}

local sqls = require("sqls")
local wk = require("which-key")

function M.setup(server, on_init, on_attach, capabilities)
    local function m_on_attach(client, buf)
        sqls.on_attach(client, buf)
        on_attach(client, buf)

        wk.register({
            ["<leader>q"] = { "<Plug>(sqls-execute-query)", "Execute query" },
        }, {
            buffer = buf,
        })
        wk.register({
            ["<leader>q"] = { "<Plug>(sqls-execute-query)", "Execute selected query" },
        }, {
            buffer = buf,
            mode = "x",
        })
    end

    server.setup({
        cmd = { "sqls", "-config", "~/.config/sqls/config.yml" },
        on_init = on_init,
        on_attach = m_on_attach,
        capabilities = capabilities,
    })
end

return M
