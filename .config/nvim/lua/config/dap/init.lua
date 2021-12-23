local M = {}

local dap = require("dap")
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

    wk.register({
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
