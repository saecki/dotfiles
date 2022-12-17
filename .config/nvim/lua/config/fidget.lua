local M = {}

local fidget = require("fidget")

function M.setup()
    fidget.setup({
        text = {
            spinner = "dots",
            done = "",
            commenced = "",
            completed = "",
        },
        fmt = {
            stack_upwards = false,
        },
    })
end

return M
