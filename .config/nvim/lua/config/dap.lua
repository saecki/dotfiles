local M = {}

local dap = require('dap')
local dap_ui = require('dapui')
local Job = require('plenary.job')
local maps = require('mappings')

local function scheduled_error(msg)
    vim.schedule(function() vim.notify(msg, vim.log.levels.ERROR) end)
end

local function is_valid_test(args)
    local is_not_cargo_check = args.cargoArgs[1] ~= "check"
    return is_not_cargo_check
end

-- filter and modify list of targets for debugging
local function sanitize_results_for_debugging(result)
    local ret = {}

    ret = vim.tbl_filter(function(value) return is_valid_test(value.args) end,
                         result)

    for i, value in ipairs(ret) do
        if value.args.cargoArgs[1] == "run" then
            ret[i].args.cargoArgs[1] = "build"
        elseif value.args.cargoArgs[1] == "test" then
            table.insert(ret[i].args.cargoArgs, 2, "--no-run")
        end
    end

    return ret
end

local function build_label(args)
    local ret = ""
    for _, value in ipairs(args.cargoArgs) do ret = ret .. value .. " " end

    for _, value in ipairs(args.cargoExtraArgs) do ret = ret .. value .. " " end

    if not vim.tbl_isempty(args.executableArgs) then
        ret = ret .. "-- "
        for _, value in ipairs(args.executableArgs) do
            ret = ret .. value .. " "
        end
    end
    return ret
end

local function get_options(result, withTitle, withIndex)
    local option_strings = withTitle and {"Debuggables: "} or {}

    for i, debuggable in ipairs(result) do
        local label = build_label(debuggable.args)
        local str =
            withIndex and string.format("%d: %s", i, label) or
                label
        table.insert(option_strings, str)
    end

    return option_strings
end

function M.mk_handler(fn)
    return function(...)
        local config_or_client_id = select(4, ...)
        local is_new = type(config_or_client_id) ~= "number"
        if is_new then
            fn(...)
        else
            local err = select(1, ...)
            local method = select(2, ...)
            local result = select(3, ...)
            local client_id = select(4, ...)
            local bufnr = select(5, ...)
            local config = select(6, ...)
            fn(err, result, { method = method, client_id = client_id, bufnr = bufnr }, config)
        end
    end
end

function M.debuggables()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local sorters = require('telescope.sorters')
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    local handler = function(_, results)
        results = sanitize_results_for_debugging(results)
        local choices = get_options(results, false, false)
        local function attach_mappings(bufnr, map)
            local function on_select()
                local choice = action_state.get_selected_entry().index

                actions.close(bufnr)
                local args = results[choice].args
                M.debug(args)
            end

            map('n', '<CR>', on_select)
            map('i', '<CR>', on_select)

            -- Additional mappings don't push the item to the tagstack.
            return true
        end

        pickers.new({}, {
            prompt_title = "Debuggables",
            finder = finders.new_table({results = choices}),
            sorter = sorters.get_generic_fuzzy_sorter(),
            previewer = nil,
            attach_mappings = attach_mappings
        }):find()
    end

    local params = {
        textDocument = vim.lsp.util.make_text_document_params(),
        position = nil,
    }
    vim.lsp.buf_request(0, "experimental/runnables", params, M.mk_handler(handler))
end

local function get_cargo_args_from_runnables_args(runnable_args)
    local cargo_args = runnable_args.cargoArgs

    table.insert(cargo_args, '--message-format=json')

    for _, value in ipairs(runnable_args.cargoExtraArgs) do
        table.insert(cargo_args, value)
    end

    if not vim.tbl_isempty(runnable_args.executableArgs) then
        table.insert(cargo_args, "--")
        for _, value in ipairs(runnable_args.executableArgs) do
            table.insert(cargo_args, value)
        end
    end

    return cargo_args
end

function M.debug(args)
    local cargo_args = get_cargo_args_from_runnables_args(args)

    vim.notify("Compiling a debug build for debugging. This might take some time...")

    Job:new({
        command = "cargo",
        args = cargo_args,
        cwd = args.workspaceRoot,
        on_exit = function(j, code)
            if code and code > 0 then
                scheduled_error("An error occured while compiling. Please fix all compilation issues and try again.")
            end
            vim.schedule(function()
                for _, value in pairs(j:result()) do
                    local json = vim.fn.json_decode(value)
                    if type(json) == "table" and json.executable ~= vim.NIL and
                        json.executable ~= nil then
                        local config = {
                            name = "Launch lldb",
                            type = "lldb",
                            request = "launch",
                            program = json.executable,
                            args = {},
                            cwd = args.workspaceRoot,
                            stopOnEntry = false,
                            runInTerminal = false,
                        }
                        dap.run(config)
                        break
                    end
                end
            end)
        end
    }):start()
end

function M.setup()
    dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode',
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

    vim.fn.sign_define("DapBreakpoint", { text='', texthl='DapBreakpoint', linehl='', numhl='' })
    vim.fn.sign_define("DapLogPoint",    { text='', texthl='DapLogPoint', linehl='', numhl='' })
    vim.fn.sign_define("DapStopped",    { text='', texthl='DapStopped', linehl='', numhl='' })

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
