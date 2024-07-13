local dap = require("dap")
local dap_ui_widgets = require("dap.ui.widgets")
local dapui = require("dapui")
local wk = require("which-key")
local shared = require("shared")
local dap_rust = require("config.dap.rust")

local M = {}

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
        command = "/usr/bin/lldb-dap",
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
                    { id = "scopes",      size = 0.4 },
                    { id = "breakpoints", size = 0.3 },
                    { id = "stacks",      size = 0.3 },
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
    -- dap.listeners.before.event_terminated["dapui_config"] = function()
    --     dapui.close()
    -- end
    -- dap.listeners.before.event_exited["dapui_config"] = function()
    --     dapui.close()
    -- end

    wk.add({
        { "<f9>",       dap.continue,   desc = "Debug continue" },
        { "<f10>",      dap.step_over,  desc = "Debug step over" },
        { "<f11>",      dap.step_into,  desc = "Debug step into" },
        { "<f12>",      dap.step_out,   desc = "Debug step out" },

        { "<leader>d",  group = "Debug" },
        { "<leader>de", dapui.toggle,   desc = "Toggle UI" },
        {
            "<leader>dh",
            function()
                M.debuggables_history({ run_first = false })
            end,
            desc = "Debug history",
            silent = false,
        },
        {
            "<leader>dH",
            function()
                M.debuggables_history({ run_first = true })
            end,
            desc = "Debug last",
            silent = false,
        },
        {
            "<leader>dd",
            function()
                M.debuggables({ current_pos = false })
            end,
            desc = "Debug",
            silent = false,
        },
        {
            "<leader>dD",
            function()
                M.debuggables({ current_pos = true })
            end,
            desc = "Debug at position",
            silent = false,
        },
        { "<leader>dR", dap.run_last,          desc = "Rerun",     silent = false },
        { "<leader>dr", dap.restart,           desc = "Restart",   silent = false },
        { "<leader>dq", dap.close,             desc = "Close" },
        { "<leader>db", dap.toggle_breakpoint, desc = "Breakpoint" },
        {
            "<leader>dc",
            function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
            desc = "Conditional breakpoint",
        },
        {
            "<leader>dl",
            function()
                dap.set_breakpoint(nil, nil, vim.fn.input("Print message: "))
            end,
            desc = "Logpoint",
        },
        {
            "<leader>dv",
            function()
                dap_ui_widgets.hover(nil, { border = shared.window.border })
            end,
            desc = "Evaluate expression",
        },
    })
end

return M
