local M = {}

local dap = require('dap')
local dap_ui = require('dapui')
local maps = require('mappings')

function M.debuggables()
    local filetype = vim.bo.filetype
    if filetype == "rust" then
        require('config.dap.rust').debuggables()
    end
end

function M.setup()
    dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode",
        name = "lldb",
    }

    dap_ui.setup {
        icons = { expanded = "▾", collapsed = "▸" },
        sidebar = {
            elements = {
                { id = "scopes", size = 0.4, },
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
    }

    vim.fn.sign_define("DapBreakpoint", { text="", texthl="DapBreakpoint", linehl="", numhl="" })
    vim.fn.sign_define("DapLogPoint",    { text="", texthl="DapLogPoint", linehl="", numhl="" })
    vim.fn.sign_define("DapStopped",    { text="", texthl="DapStopped", linehl="", numhl="" })

    maps.nmap("<F8>",       dap_ui.toggle)
    maps.nmap("<leader>dd", M.debuggables, { silent = false })
    maps.nmap("<leader>dD", dap.run_last, {silent = false })
    maps.nmap("<leader>dr", dap.restart, {silent = false })
    maps.nmap("<leader>dq", dap.close)

    maps.nmap("<f9>",  dap.continue)
    maps.nmap("<f10>", dap.step_over)
    maps.nmap("<f11>", dap.step_into)
    maps.nmap("<f12>", dap.step_out)

    maps.nmap("<leader>db", dap.toggle_breakpoint)
    maps.nmap("<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
    maps.nmap("<leader>dL", function() dap.set_breakpoint(nil, nil, vim.fn.input("Print message: ")) end)
end

return M
