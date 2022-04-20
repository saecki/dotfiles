local M = {}

local dap = require("dap")
local dap_ui = require("dapui")
local wk = require("which-key")

function M.debuggables()
    local filetype = vim.bo.filetype
    if filetype == "rust" then
        require("config.dap.rust").debuggables()
    end
end

function M.setup()
    dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode",
        name = "lldb",
    }

    -- stylua: ignore start
    vim.fn.sign_define("DapBreakpoint", { text="", texthl="DapBreakpoint", linehl="", numhl="" })
    vim.fn.sign_define("DapLogPoint",   { text="", texthl="DapLogPoint", linehl="", numhl="" })
    vim.fn.sign_define("DapStopped",    { text="", texthl="DapStopped", linehl="", numhl="" })
    -- stylua: ignore end

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
        ["<f9>"] = { dap.continue, "Debug continue" },
        ["<f10>"] = { dap.step_over, "Debug step over" },
        ["<f11>"] = { dap.step_into, "Debug step into" },
        ["<f12>"] = { dap.step_out, "Debug step out" },
        ["<leader>d"] = {
            name = "Debug",
            ["d"] = { M.debuggables, "Debug", silent = false },
            ["D"] = { dap.run_last, "Rerun", silent = false },
            ["r"] = { dap.restart, "Restart", silent = false },
            ["q"] = { dap.close, "Close" },
            ["b"] = { dap.toggle_breakpoint, "Breakpoint" },
            ["c"] = {
                function()
                    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                "Conditional breakpoint",
            },
            ["l"] = {
                function()
                    dap.set_breakpoint(nil, nil, vim.fn.input("Print message: "))
                end,
                "Logpoint",
            },
        },
    })
end

return M
