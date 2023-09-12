local M = {}

local dap = require("dap")
local dap_ui_widgets = require("dap.ui.widgets")
local dapui = require("dapui")
local wk = require("which-key")
local util = require("util")
local dap_rust = require("config.dap.rust")

function M.debuggables_history(opts)
    local filetype = vim.bo.filetype
    if filetype == "rust" then
        dap_rust.debuggables_history(opts)
    end
end

function M.debuggables(opts)
    local filetype = vim.bo.filetype
    if filetype == "rust" then
        dap_rust.debuggables(opts)
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

    dapui.setup({
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
    -- automatically open ui
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    wk.register({
        ["<f9>"] = { dap.continue, "Debug continue" },
        ["<f10>"] = { dap.step_over, "Debug step over" },
        ["<f11>"] = { dap.step_into, "Debug step into" },
        ["<f12>"] = { dap.step_out, "Debug step out" },
        ["<leader>d"] = {
            name = "Debug",
            ["e"] = { dapui.toggle, "Toggle UI" },
            ["h"] = { util.wrap(M.debuggables_history, { run_first = false }), "Debug history", silent = false },
            ["H"] = { util.wrap(M.debuggables_history, { run_first = true }), "Debug last", silent = false },
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
            ["v"] = {
                function() dap_ui_widgets.hover(nil, { border = shared.window.border }) end,
                "Evaluate expression",
            },
        },
    })
end

return M
