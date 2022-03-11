local M = {}

local sqls = require("sqls")

function M.setup(server, on_init, on_attach, capabilities)
    local function m_on_attach(client, buf)
        sqls.on_attach(client, buf)
        on_attach(client, buf)
    end

    server:setup({
        cmd = { "sqls", "-config", "~/.config/sqls/config.yml" },
        on_init = on_init,
        on_attach = m_on_attach,
        capabilities = capabilities,
    })
end

return M
