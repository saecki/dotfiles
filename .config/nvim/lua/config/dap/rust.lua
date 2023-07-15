local M = {}

local dap = require("dap")
local Job = require("plenary.job")
local telescope_pickers = require("telescope.pickers")
local telescope_finders = require("telescope.finders")
local telescope_sorters = require("telescope.sorters")
local telescope_actions = require("telescope.actions")
local telescope_action_state = require("telescope.actions.state")

local function input_cmd_args(suggestion)
    local suggestion = suggestion or M.last_cmd_args_str or ""
    M.last_cmd_args_str = vim.fn.input("Args: ", suggestion)
    return vim.split(M.last_cmd_args_str, " ", { plain = true, trimempty = true })
end

M.configurations = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            local suggestion = M.last_program or (vim.fn.getcwd() .. "/target/debug/")
            M.last_program = vim.fn.input("Path to executable: ", suggestion, "file")
            return M.last_program
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = input_cmd_args,
        runInTerminal = false,

        initCommands = function()
            local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

            local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
            local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

            local commands = {}
            local file = io.open(commands_file, "r")
            if file then
                for line in file:lines() do
                    table.insert(commands, line)
                end
                file:close()
            end
            table.insert(commands, 1, script_import)

            return commands
        end,
    },
}

-- filter and modify list of targets for debugging
local function sanitize_results_for_debugging(results)
    return vim.tbl_filter(function(r)
        if r.args.cargoArgs[1] == "check" then
            return false
        elseif r.args.cargoArgs[1] == "run" then
            r.args.cargoArgs[1] = "build"
        elseif r.args.cargoArgs[1] == "test" then
            table.insert(r.args.cargoArgs, 2, "--no-run")
        end

        return true
    end, results)
end

local function get_choice_strs(result, withTitle, withIndex)
    local option_strings = withTitle and { "Debuggables: " } or {}

    for i, debuggable in ipairs(result) do
        local args = debuggable.args
        local label = ""
        for _, a in ipairs(args.cargoArgs) do
            label = label .. a .. " "
        end
        for _, a in ipairs(args.cargoExtraArgs) do
            label = label .. a .. " "
        end

        if not vim.tbl_isempty(args.executableArgs) then
            label = label .. "-- "
            for _, value in ipairs(args.executableArgs) do
                label = label .. value .. " "
            end
        end

        local str = withIndex and string.format("%d: %s", i, label) or label
        table.insert(option_strings, str)
    end

    return option_strings
end

function M.debuggables(opts)
    local active_clients = vim.lsp.get_active_clients()
    if not next(active_clients) then
        vim.notify("No lsp clients attached")
        return
    end

    local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local debuggables_handler = function(err, results)
        print(vim.inspect(err))
        print(vim.inspect(results))
        if results == nil then
            vim.notify("No debuggables found")
            return
        end

        results = sanitize_results_for_debugging(results)
        if not next(results) then
            vim.notify("No debuggables found")
            return
        end

        if opts.current_pos then
            results = vim.tbl_filter(function(r)
                if not r.location then
                    return true
                end

                local range = r.location.targetRange
                return (current_line >= range.start.line) and (current_line < range["end"].line)
            end, results)

            if not next(results) then
                vim.notify("No debuggables found for current position")
                return
            end
        end

        local choices = get_choice_strs(results, false, false)

        local function attach_mappings(bufnr, map)
            local function on_select()
                local choice = telescope_action_state.get_selected_entry().index

                telescope_actions.close(bufnr)
                M.debug(results[choice])
            end

            map("n", "<cr>", on_select)
            map("i", "<cr>", on_select)

            -- Additional mappings don't push the item to the tagstack.
            return true
        end

        telescope_pickers
            .new({}, {
                prompt_title = "Debuggables",
                finder = telescope_finders.new_table({ results = choices }),
                sorter = telescope_sorters.get_generic_fuzzy_sorter(),
                previewer = nil,
                attach_mappings = attach_mappings,
            })
            :find()
    end

    local params = {
        textDocument = vim.lsp.util.make_text_document_params(),
        position = nil,
    }
    vim.lsp.buf_request(0, "experimental/runnables", params, debuggables_handler)
end

function M.debug(runnable)
    local cargo_args = runnable.args.cargoArgs
    table.insert(cargo_args, "--message-format=json")
    for _, value in ipairs(runnable.args.cargoExtraArgs) do
        table.insert(cargo_args, value)
    end

    vim.notify("Compiling - This might take some time...")

    local cmd_args = runnable.args.executableArgs or {}
    local cmd_args_str = table.concat(cmd_args, " ")
    local cmd_args = input_cmd_args(cmd_args_str)

    local on_exit = function(j, code)
        if code and code > 0 then
            vim.schedule(function()
                vim.notify("An error occured while compiling.", vim.log.levels.ERROR)
            end)
        end
        
        vim.schedule(function()
            for _, value in pairs(j:result()) do
                local json = vim.fn.json_decode(value)
                if type(json) == "table" and json.executable ~= vim.NIL and json.executable ~= nil then
                    M.last_program = json.executable

                    local config = {
                        name = "Launch",
                        type = "lldb",
                        request = "launch",
                        program = json.executable,
                        args = cmd_args,
                        cwd = runnable.args.workspaceRoot,
                        stopOnEntry = false,
                        runInTerminal = false,
                    }
                    dap.run(config)
                    break
                end
            end
        end)
    end

    Job:new({
        command = "cargo",
        args = cargo_args,
        cwd = runnable.args.workspaceRoot,
        on_exit = on_exit,
    }):start()
end

return M
