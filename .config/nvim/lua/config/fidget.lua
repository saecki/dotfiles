local fidget = require("fidget")

local M = {}

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
