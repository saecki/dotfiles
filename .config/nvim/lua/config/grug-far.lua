local grug_far = require("grug-far")
local wk = require("which-key.config")

local M = {}

local function toggle_flag(flag)
    return function()
        local state = unpack(grug_far.toggle_flags({ flag }))
        vim.notify(string.format("grug-far: toggled %s %s", flag, state and "ON" or "OFF"))
    end
end

function M.setup()
    grug_far.setup({
        debounceMs = 100,
    })

    -- local key mappings
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user.config.grug_far.keybinds", {}),
        pattern = { "grug-far" },
        callback = function(ev)
            wk.add({
                buffer = ev.buffer,
                { "<localleader>H", toggle_flag("--hidden"),        desc = "--hidden" },
                { "<localleader>I", toggle_flag("--ignore-case"),   desc = "--ignore-case" },
                { "<localleader>F", toggle_flag("--fixed-strings"), desc = "--fixed-strings" },
            })
        end,
    })

    wk.add({
        { "<leader>s",  group = "Search/Replace" },
        { "<leader>sp", grug_far.open,           desc = "Project" },
        { "<leader>sp", grug_far.open,           desc = "Project", mode = "v" },
    })
end

return M
