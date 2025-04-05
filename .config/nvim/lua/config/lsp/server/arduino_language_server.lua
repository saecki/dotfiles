local M = {}

local DEFAULT_FQBN = "arduino:avr:uno"
local fqbns = {}

function M.setup(server)
    local function on_new_config(config, root_dir)
        local partial_cmd = server:get_default_options().cmd
        local fqbn = fqbns[root_dir]
        if not fqbn then
            vim.notify(("Could not find which FQBN to use in %q. Defaulting to %q."):format(root_dir, DEFAULT_FQBN))
            fqbn = DEFAULT_FQBN
        end
        config.cmd = vim.list_extend(partial_cmd, { "-fqbn", fqbn })
    end

    server.setup({
        on_new_config = on_new_config,
    })
end

return M
