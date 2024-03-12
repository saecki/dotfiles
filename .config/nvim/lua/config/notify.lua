local notify = require("notify")
local wk = require("which-key")

local M = {}

function M.setup()
    vim.notify = notify

    wk.register({
        ["<leader>n"] = {
            name = "Notification",
            ["d"] = { notify.dismiss, "Dismiss" },
            ["D"] = {
                function()
                    notify.dismiss({ pending = true })
                end,
                "Dismiss all",
            },
            ["h"] = { notify._print_history, "History" },
        },
    })
end

return M
