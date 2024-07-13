local notify = require("notify")
local wk = require("which-key")

local M = {}

function M.setup()
    vim.notify = notify

    wk.add({
        { "<leader>n",  group = "Notification" },
        { "<leader>nd", notify.dismiss,                                    desc = "Dismiss" },
        { "<leader>nD", function() notify.dismiss({ pending = true }) end, desc = "Dismiss all", },
        { "<leader>nh", notify._print_history,                             desc = "History" },
    })
end

return M
