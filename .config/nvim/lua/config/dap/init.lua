local M = {}

local dap = require("dap")
local dap_ui = require("dapui")
local wk = require("which-key")
local util = require("util")
local dap_rust = require("config.dap.rust")

function M.debuggables(prompt)
    local filetype = vim.bo.filetype
    if filetype == "rust" then
        dap_rust.debuggables(prompt)
    end
end

function M.setup()
    dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode",
        name = "lldb",
    }

    dap.configurations.rust = dap_rust.configurations

    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "", numhl = "" })

    dap_ui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        layouts = {
            {
                elements = {
                    { id = "scopes", size = 0.4 },
                    { id = "breakpoints", size = 0.3 },
                    { id = "stacks", size = 0.3 },
                },
                size = 80,
                position = "left",
            },
            {
                elements = { "repl" },
                size = 20,
                position = "bottom",
            },
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
        ["<f9>"] = { dap.continue, "Debug continue" },
        ["<f10>"] = { dap.step_over, "Debug step over" },
        ["<f11>"] = { dap.step_into, "Debug step into" },
        ["<f12>"] = { dap.step_out, "Debug step out" },
        ["<leader>d"] = {
            name = "Debug",
            ["e"] = { dap_ui.toggle, "Toggle UI" },
            ["d"] = { util.wrap(M.debuggables, { current_pos = false }), "Debug", silent = false },
            ["D"] = { util.wrap(M.debuggables, { current_pos = true }), "Debug at position", silent = false },
            ["R"] = { dap.run_last, "Rerun", silent = false },
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
