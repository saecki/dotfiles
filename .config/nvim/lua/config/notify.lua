local M = {}

local notify = require("notify")
local wk = require("which-key")

function M.setup()
    vim.notify = notify

    wk.register({
        ["<leader>n"] = {
            name = "Notification",
            ["d"] = { notify.dismiss, "Dismiss" },
            ["h"] = { notify._print_history, "History" },
        },
    })
end

return M
