local M = {}

local dap = require('dap')
local dap_ui = require('dapui')
local maps = require('mappings')

function M.setup()
    dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode',
        name = "lldb",
    }

    local lldb_conf =  {
        {
            name = "Launch lldb",
            type = "lldb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},

            -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
            --
            --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
            --
            -- Otherwise you might get the following error:
            --
            --    Error on launch: Failed to attach to the target process
            --
            -- But you should be aware of the implications:
            -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
            runInTerminal = false,
        },
    }
    dap.configurations.c = lldb_conf
    dap.configurations.cpp = lldb_conf
    dap.configurations.rust = lldb_conf

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

    vim.fn.sign_define("DapBreakpoint", { text='', texthl='DapBreakpoint', linehl='', numhl='' })
    vim.fn.sign_define("DapStopped",    { text='', texthl='DapStopped', linehl='', numhl='' })

    maps.nnoremap("<F8>",       dap_ui.toggle,         { silent = true })
    maps.nnoremap("<leader>db", dap.toggle_breakpoint, { silent = true })
    maps.nnoremap("<leader>dc", dap.continue,          { silent = true })
    maps.nnoremap("<leader>dl", dap.run_last,          { silent = true })
end

return M
