local M = {}

local dap_ui = require("dapui")
local wk = require("which-key")

function M.setup()
    dap_ui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        sidebar = {
            elements = {
                { id = "scopes", size = 0.4 },
                { id = "breakpoints", size = 0.3 },
                { id = "stacks", size = 0.3 },
            },
            size = 80,
            position = "left",
        },
        tray = {
            elements = { "repl" },
            size = 20,
            position = "bottom",
        },
        floating = {
            max_height = nil,
            max_width = nil,
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
        windows = { indent = 1 },
    })

    wk.register({
        ["<F8>"] = { dap_ui.toggle, "Debug UI toggle" },
    })
end

return M
