local M = {}

local dap = require("dap")
local maps = require("util.maps")

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

	maps.nmap("<leader>dd", M.debuggables, { silent = false })
	maps.nmap("<leader>dD", dap.run_last, { silent = false })
	maps.nmap("<leader>dr", dap.restart, { silent = false })
	maps.nmap("<leader>dq", dap.close)

	maps.nmap("<f9>", dap.continue)
	maps.nmap("<f10>", dap.step_over)
	maps.nmap("<f11>", dap.step_into)
	maps.nmap("<f12>", dap.step_out)

	maps.nmap("<leader>db", dap.toggle_breakpoint)
	maps.nmap("<leader>dB", function()
		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end)
	maps.nmap("<leader>dL", function()
		dap.set_breakpoint(nil, nil, vim.fn.input("Print message: "))
	end)
end

return M
